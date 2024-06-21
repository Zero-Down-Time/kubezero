#!/bin/bash
#set -eEx
#set -o pipefail
set -x

ARTIFACTS=($(echo $1 | tr "," "\n"))
ACTION=${2:-apply}

LOCAL_DEV=1

#VERSION="latest"
KUBE_VERSION="$(kubectl version -o json | jq -r .serverVersion.gitVersion)"

WORKDIR=$(mktemp -p /tmp -d kubezero.XXX)
[ -z "$DEBUG" ] && trap 'rm -rf $WORKDIR' ERR EXIT

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/libhelm.sh
CHARTS="$(dirname $SCRIPT_DIR)/charts"

### Various hooks for modules

################
# cert-manager #
################
function cert-manager-post() {
  # If any error occurs, wait for initial webhook deployment and try again
  # see: https://cert-manager.io/docs/concepts/webhook/#webhook-connection-problems-shortly-after-cert-manager-installation

  if [ $rc -ne 0 ]; then
    wait_for "kubectl get deployment -n $namespace cert-manager-webhook"
    kubectl rollout status deployment -n $namespace cert-manager-webhook
    wait_for 'kubectl get validatingwebhookconfigurations -o yaml | grep "caBundle: LS0"'
    apply
  fi

  wait_for "kubectl get ClusterIssuer -n $namespace kubezero-local-ca-issuer"
  kubectl wait --timeout=180s --for=condition=Ready -n $namespace ClusterIssuer/kubezero-local-ca-issuer
}


###########
# ArgoCD  #
###########
function argocd-pre() {
  for f in $CLUSTER/secrets/argocd-*.yaml; do
    kubectl apply -f $f
  done
}


###########
# Metrics #
###########
# Cleanup patch jobs from previous runs , ArgoCD does this automatically
function metrics-pre() {
  kubectl delete jobs --field-selector status.successful=1 -n monitoring
}


### Main
get_kubezero_values

# Always use embedded kubezero chart
helm template $CHARTS/kubezero -f $WORKDIR/kubezero-values.yaml --kube-version $KUBE_VERSION --version ~$KUBE_VERSION --devel --output-dir $WORKDIR

# Resolve all the all enabled artifacts
if [ ${ARTIFACTS[0]} == "all" ]; then
  ARTIFACTS=($(ls $WORKDIR/kubezero/templates | sed -e 's/.yaml//g'))
fi

if [ $ACTION == "apply" -o $ACTION == "crds" ]; then
  for t in ${ARTIFACTS[@]}; do
    _helm $ACTION $t || true
  done

# Delete in reverse order, continue even if errors
elif [ $ACTION == "delete" ]; then
  set +e
  for (( idx=${#ARTIFACTS[@]}-1 ; idx>=0 ; idx-- )) ; do
    _helm delete ${ARTIFACTS[idx]} || true
  done
fi
