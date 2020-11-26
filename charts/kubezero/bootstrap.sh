#!/bin/bash
set -ex

ACTION=$1
ARTIFACTS=("$2")
VALUES=$3
LOCATION=${4:-""}

DEPLOY_DIR=$( dirname $( realpath $0 ))
which yq || { echo "yq not found!"; exit 1; }

TMPDIR=$(mktemp -d kubezero.XXX)

# First lets generate kubezero.yaml
# This will be stored as secret during the initial kubezero chart install
helm template $DEPLOY_DIR -f $VALUES -f cloudbender.yaml --set argo=false > $TMPDIR/kubezero.yaml

if [ ${ARTIFACTS[0]} == "all" ]; then
  ARTIFACTS=($(yq r -p p $TMPDIR/kubezero.yaml "*.enabled" | awk -F "." '{print $1}'))
fi

# Update only if we use upstream
if [ -z "$LOCATION" ]; then
  helm repo add kubezero https://zero-down-time.github.io/kubezero
  helm repo update
fi

# Waits for max 300s and retries
function wait_for() {
  local TRIES=0
  while true; do
    eval " $@" && break
    [ $TRIES -eq 100 ] && return 1
    let TRIES=$TRIES+1
    sleep 3
  done
}


function chart_location() {
  if [ -z "$LOCATION" ]; then
    echo "$1 --repo https://zero-down-time.github.io/kubezero"
  else
    echo "$LOCATION/$1"
  fi
}


function _helm() {
  local action=$1
  local chart=$2
  local release=$3
  local namespace=$4
  shift 4

  helm template $(chart_location $chart) --namespace $namespace --name-template $release --skip-crds $@ > $TMPDIR/helm.yaml

  if [ $action == "apply" ]; then
    # make sure namespace exists prior to calling helm as the create-namespace options doesn't work
    kubectl get ns $namespace || kubectl create ns $namespace
  fi

  # If resources are out of the single $namespace, apply without restrictions
  nr_ns=$(grep -e '^  namespace:' $TMPDIR/helm.yaml  | sed "s/\"//g" | sort | uniq | wc -l)
  if [ $nr_ns -gt 1 ]; then
    kubectl $action -f $TMPDIR/helm.yaml
  else
    kubectl $action --namespace $namespace -f $TMPDIR/helm.yaml
  fi
}


function deploy() {
  _helm apply $@
}


function delete() {
  _helm delete $@
}


function is_enabled() {
  local chart=$1

  enabled=$(yq r $TMPDIR/kubezero.yaml ${chart}.enabled)
  if [ "$enabled" == "true" ]; then
    yq r $TMPDIR/kubezero.yaml ${chart}.values > $TMPDIR/values.yaml
    return 0
  fi
  return 1
}


##########
# Calico #
##########
function calico() {
  local chart="kubezero-calico"
  local release="calico"
  local namespace="kube-system"

  local task=$1

  if [ $task == "deploy" ]; then
    deploy $chart $release $namespace -f $TMPDIR/values.yaml && rc=$? || rc=$?
    kubectl apply -f $TMPDIR/helm.yaml
  # Don't delete the only CNI
  #elif [ $task == "delete" ]; then
  #  delete $chart $release $namespace -f $TMPDIR/values.yaml
  elif [ $task == "crds" ]; then
    helm template $(chart_location $chart) --namespace $namespace --name-template $release --skip-crds > $TMPDIR/helm-no-crds.yaml
    helm template $(chart_location $chart) --namespace $namespace --name-template $release --include-crds > $TMPDIR/helm-crds.yaml
    diff -e $TMPDIR/helm-no-crds.yaml $TMPDIR/helm-crds.yaml | head -n-1 | tail -n+2 > $TMPDIR/crds.yaml
    kubectl apply -f $TMPDIR/crds.yaml
  fi
}


################
# cert-manager #
################
function cert-manager() {
  local chart="kubezero-cert-manager"
  local release="cert-manager"
  local namespace="cert-manager"

  local task=$1

  if [ $task == "deploy" ]; then
    deploy $chart $release $namespace -f $TMPDIR/values.yaml && rc=$? || rc=$?

    # If any error occurs, wait for initial webhook deployment and try again
    # see: https://cert-manager.io/docs/concepts/webhook/#webhook-connection-problems-shortly-after-cert-manager-installation
    if [ $rc -ne 0 ]; then
      wait_for "kubectl get deployment -n $namespace cert-manager-webhook"
      kubectl rollout status deployment -n $namespace cert-manager-webhook
      wait_for 'kubectl get validatingwebhookconfigurations -o yaml | grep "caBundle: LS0"'
      deploy $chart $release $namespace -f $TMPDIR/values.yaml
    fi

    wait_for "kubectl get ClusterIssuer -n $namespace kubezero-local-ca-issuer"
    kubectl wait --timeout=180s --for=condition=Ready -n $namespace ClusterIssuer/kubezero-local-ca-issuer

  elif [ $task == "delete" ]; then
    delete $chart $release $namespace -f $TMPDIR/values.yaml
    kubectl delete ns $namespace

  elif [ $task == "crds" ]; then
    helm template $(chart_location $chart) --namespace $namespace --name-template $release --skip-crds --set cert-manager.installCRDs=false > $TMPDIR/helm-no-crds.yaml
    helm template $(chart_location $chart) --namespace $namespace --name-template $release --include-crds --set cert-manager.installCRDs=true > $TMPDIR/helm-crds.yaml
    diff -e $TMPDIR/helm-no-crds.yaml $TMPDIR/helm-crds.yaml | head -n-1 | tail -n+2 > $TMPDIR/crds.yaml
    kubectl apply -f $TMPDIR/crds.yaml
  fi
}


########
# Kiam #
########
function kiam() {
  local chart="kubezero-kiam"
  local release="kiam"
  local namespace="kube-system"

  local task=$1

  if [ $task == "deploy" ]; then
    # Certs only first
    deploy $chart $release $namespace --set kiam.enabled=false
    kubectl wait --timeout=120s --for=condition=Ready -n kube-system Certificate/kiam-server

    # Make sure kube-system and cert-manager are allowed to kiam
    kubectl annotate --overwrite namespace kube-system 'iam.amazonaws.com/permitted=.*'
    kubectl annotate --overwrite namespace cert-manager 'iam.amazonaws.com/permitted=.*CertManagerRole.*'

    # Get kiam rolled out and make sure it is working
    deploy $chart $release $namespace -f $TMPDIR/values.yaml
    wait_for 'kubectl get daemonset -n kube-system kiam-agent'
    kubectl rollout status daemonset -n kube-system kiam-agent

  elif [ $task == "delete" ]; then
    delete $chart $release $namespace -f $TMPDIR/values.yaml
  fi
}


#######
# EBS #
#######
function aws-ebs-csi-driver() {
  local chart="kubezero-aws-ebs-csi-driver"
  local release="aws-ebs-csi-driver"
  local namespace="kube-system"

  local task=$1

  if [ $task == "deploy" ]; then
    deploy $chart $release $namespace -f $TMPDIR/values.yaml
  elif [ $task == "delete" ]; then
    delete $chart $release $namespace -f $TMPDIR/values.yaml
  fi
}


#########
# Istio #
#########
function istio() {
  local chart="kubezero-istio"
  local release="istio"
  local namespace="istio-system"

  local task=$1

  if [ $task == "deploy" ]; then
    deploy $chart $release $namespace -f $TMPDIR/values.yaml

  elif [ $task == "delete" ]; then
    delete $chart $release $namespace -f $TMPDIR/values.yaml
    kubectl delete ns istio-system

  elif [ $task == "crds" ]; then
    helm template $(chart_location $chart) --namespace $namespace --name-template $release --skip-crds > $TMPDIR/helm-no-crds.yaml
    helm template $(chart_location $chart) --namespace $namespace --name-template $release --include-crds > $TMPDIR/helm-crds.yaml
    diff -e $TMPDIR/helm-no-crds.yaml $TMPDIR/helm-crds.yaml | head -n-1 | tail -n+2 > $TMPDIR/crds.yaml
    kubectl apply -f $TMPDIR/crds.yaml
  fi
}

#################
# Istio Ingress #
#################
function istio-ingress() {
  local chart="kubezero-istio-ingress"
  local release="istio-ingress"
  local namespace="istio-ingress"

  local task=$1

  if [ $task == "deploy" ]; then
    deploy $chart $release $namespace -f $TMPDIR/values.yaml

  elif [ $task == "delete" ]; then
    delete $chart $release $namespace -f $TMPDIR/values.yaml
    kubectl delete ns istio-ingress
  fi
}


###########
# Metrics #
###########
function metrics() {
  local chart="kubezero-metrics"
  local release="metrics"
  local namespace="monitoring"

  local task=$1

  if [ $task == "deploy" ]; then
    deploy $chart $release $namespace -f $TMPDIR/values.yaml

  elif [ $task == "delete" ]; then
    delete $chart $release $namespace -f $TMPDIR/values.yaml
    kubectl delete ns monitoring

  elif [ $task == "crds" ]; then
    helm template $(chart_location $chart) --namespace $namespace --name-template $release --skip-crds > $TMPDIR/helm-no-crds.yaml
    helm template $(chart_location $chart) --namespace $namespace --name-template $release --include-crds > $TMPDIR/helm-crds.yaml
    diff -e $TMPDIR/helm-no-crds.yaml $TMPDIR/helm-crds.yaml | head -n-1 | tail -n+2 > $TMPDIR/crds.yaml
    kubectl apply -f $TMPDIR/crds.yaml
  fi
}


###########
# Logging #
###########
function logging() {
  local chart="kubezero-logging"
  local release="logging"
  local namespace="logging"

  local task=$1

  if [ $task == "deploy" ]; then
    deploy $chart $release $namespace -a "monitoring.coreos.com/v1" -f $TMPDIR/values.yaml

    kubectl annotate --overwrite namespace logging 'iam.amazonaws.com/permitted=.*ElasticSearchSnapshots.*'

  elif [ $task == "delete" ]; then
    delete $chart $release $namespace -f $TMPDIR/values.yaml
    kubectl delete ns logging

  # Doesnt work right now due to V2 Helm implementation of the eck-operator-crd chart
  #elif [ $task == "crds" ]; then
  #  helm template $(chart_location $chart) --namespace $namespace --name-template $release --skip-crds > $TMPDIR/helm-no-crds.yaml
  #  helm template $(chart_location $chart) --namespace $namespace --name-template $release --include-crds > $TMPDIR/helm-crds.yaml
  #  diff -e $TMPDIR/helm-no-crds.yaml $TMPDIR/helm-crds.yaml | head -n-1 | tail -n+2 > $TMPDIR/crds.yaml
  #  kubectl apply -f $TMPDIR/crds.yaml
  fi
}


##########
# ArgoCD #
##########
function argo-cd() {
  local chart="kubezero-argo-cd"
  local release="argocd"
  local namespace="argocd"

  local task=$1

  if [ $task == "deploy" ]; then
    deploy $chart $release $namespace -f $TMPDIR/values.yaml

    # Install the kubezero app of apps
    # deploy kubezero kubezero $namespace -f $TMPDIR/kubezero.yaml

  elif [ $task == "delete" ]; then
    delete $chart $release $namespace -f $TMPDIR/values.yaml
    kubectl delete ns argocd

  elif [ $task == "crds" ]; then
    helm template $(chart_location $chart) --namespace $namespace --name-template $release --skip-crds > $TMPDIR/helm-no-crds.yaml
    helm template $(chart_location $chart) --namespace $namespace --name-template $release --include-crds > $TMPDIR/helm-crds.yaml
    diff -e $TMPDIR/helm-no-crds.yaml $TMPDIR/helm-crds.yaml | head -n-1 | tail -n+2 > $TMPDIR/crds.yaml
    kubectl apply -f $TMPDIR/crds.yaml
  fi
}


## MAIN ##
if [ $1 == "deploy" ]; then
  for t in ${ARTIFACTS[@]}; do
    is_enabled $t && $t deploy
  done

elif [ $1 == "crds" ]; then
  for t in ${ARTIFACTS[@]}; do
    is_enabled $t && $t crds
  done

# Delete in reverse order, continue even if errors
elif [ $1 == "delete" ]; then
  set +e
  for (( idx=${#ARTIFACTS[@]}-1 ; idx>=0 ; idx-- )) ; do
    is_enabled ${ARTIFACTS[idx]} && ${ARTIFACTS[idx]} delete
  done
fi

[ "$DEBUG" == "" ] && rm -rf $TMPDIR
