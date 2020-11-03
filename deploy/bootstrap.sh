#!/bin/bash
set -ex

LOCATION=${1-""}

# Update only if we use upstream
if [ -z "$LOCATION" ]; then
  helm repo add kubezero https://zero-down-time.github.io/kubezero
  helm repo update
fi

DEPLOY_DIR=$( dirname $( realpath $0 ))
which yq || { echo "yq not found!"; exit 1; }

# Waits for max 300s and retries
function wait_for() {
  local TRIES=0
  while true; do
    $@ && break
    [ $TRIES -eq 200 ] && return 1
    let TRIES=$TRIES+1
    sleep 3
  done
}

function _helm() {
  local action=$1
  local chart=$2
  local release=$3
  local namespace=$4
  shift 4

  local location

  if [ -z "$LOCATION" ]; then
    location="$chart --repo https://zero-down-time.github.io/kubezero"
  else
    location="$LOCATION/$chart"
  fi
  
  [ -n "$namespace" ] && kubectl get ns $namespace || kubectl create ns $namespace
  helm template $location --namespace $namespace --name-template $release $@ | kubectl $action -f -
}

function deploy() {
  _helm apply $@
}

function delete() {
  _helm delete $@
}

################
# cert-manager #
################

# Let's start with minimal cert-manager to get the webhook in place
deploy kubezero-cert-manager cert-manager cert-manager

echo "Waiting for cert-manager to be ready..."
wait_for kubectl get deployment -n cert-manager cert-manager-webhook 2>/dev/null 1>&2
kubectl rollout status deployment -n cert-manager cert-manager-webhook
wait_for kubectl get validatingwebhookconfigurations -o yaml | grep "caBundle: LS0" 2>/dev/null 1>&2

# Either inject cert-manager backup or bootstrap
if [ -f cert-manager-backup.yaml ]; then
	kubectl apply -f cert-manager-backup.yaml
else
  deploy kubezero-cert-manager cert-manager cert-manager --set localCA.enabled=true
	wait_for kubectl get Issuer -n kube-system kubezero-local-ca-issuer 2>/dev/null 1>&2
	kubectl wait --for=condition=Ready -n kube-system Issuer/kubezero-local-ca-issuer
fi

echo "KubeZero installed successfully."
read 

# Remove all kubezero
delete kubezero-cert-manager cert-manager cert-manager

exit 0

# Determine if we bootstrap or update
helm list -n argocd -f kubezero -q | grep -q kubezero && rc=$? || rc=$?
if [ $rc -eq 0 ]; then
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
else


  # Make sure kube-system is allowed to kiam
  kubectl annotate --overwrite namespace kube-system 'iam.amazonaws.com/permitted=.*'

  # Now that we have the cert-manager webhook, get the kiam certs in place but do NOT deploy kiam yet
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml -f $DEPLOY_DIR/values-step-3.yaml > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
  kubectl wait --for=condition=Ready -n kube-system certificates/kiam-server

  # Now lets make sure kiam is working
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml -f $DEPLOY_DIR/values-step-4.yaml > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
  wait_for kubectl get daemonset -n kube-system kiam-agent 2>/dev/null 1>&2
  kubectl rollout status daemonset -n kube-system kiam-agent

  # Install Istio if enabled, but keep ArgoCD istio support disabled for now in case
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml -f $DEPLOY_DIR/values-step-5.yaml  > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
  wait_for kubectl get deployment -n istio-operator istio-operator 2>/dev/null 1>&2
  kubectl rollout status deployment -n istio-operator istio-operator

  # Metrics
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml -f $DEPLOY_DIR/values-step-6.yaml  > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
  wait_for kubectl get crds servicemonitors.monitoring.coreos.com 2>/dev/null 1>&2

  # Finally we could enable the actual config and deploy all
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
fi
