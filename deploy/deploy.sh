#!/bin/bash
set -e

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

helm repo add kubezero https://zero-down-time.github.io/kubezero
helm repo update

# Determine if we bootstrap or update
helm list -n argocd -f kubezero -q | grep -q kubezero && rc=$? || rc=$?
if [ $rc -eq 0 ]; then
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
else
  # During bootstrap we first generate a minimal values.yaml to prevent various deadlocks

  # Generate ArgoCD password if not in values.yaml yet and add it
  grep -q argocdServerAdminPassword values.yaml && rc=$? || rc=$?
  if [ $rc -ne 0 ]; then
    _argo_date="$(date -u --iso-8601=seconds)"
    _argo_passwd="$($DEPLOY_DIR/argocd_password.py)"

    cat <<EOF > _argocd_values.yaml
argo-cd:
  configs:
    secret:
      # ArgoCD password: ${_argo_passwd%%:*} Please move to secure location !
      argocdServerAdminPassword: "${_argo_passwd##*:}"
      argocdServerAdminPasswordMtime: "$_argo_date"
EOF
    yq merge -i --overwrite values.yaml _argocd_values.yaml && rm -f _argocd_values.yaml
  fi

  # Deploy initial argocd
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml -f $DEPLOY_DIR/values-step-1.yaml > generated-values.yaml
  helm install -n argocd kubezero kubezero/kubezero-argo-cd --create-namespace -f generated-values.yaml
  # Wait for argocd-server to be running
  kubectl rollout status deployment -n argocd kubezero-argocd-server

  # Now wait for cert-manager and the local CA to be bootstrapped
  echo "Waiting for cert-manager to be deployed..."
  wait_for kubectl get deployment -n cert-manager cert-manager-webhook 2>/dev/null 1>&2
  kubectl rollout status deployment -n cert-manager cert-manager-webhook

  # Either inject cert-manager backup or bootstrap
  if [ -f cert-manager-backup.yaml ]; then
    kubectl apply -f cert-manager-backup.yaml
  else
    helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml -f $DEPLOY_DIR/values-step-2.yaml > generated-values.yaml
    helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
    wait_for kubectl get Issuer -n kube-system kubezero-local-ca-issuer 2>/dev/null 1>&2
    kubectl wait --for=condition=Ready -n kube-system Issuer/kubezero-local-ca-issuer
  fi

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
