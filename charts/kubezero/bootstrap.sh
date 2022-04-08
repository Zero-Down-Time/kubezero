#!/bin/bash
set -ex

ACTION=$1
ARTIFACTS=($(echo $2 | tr "," "\n"))
CLUSTER=$3
LOCATION=${4:-""}

which yq || { echo "yq not found!"; exit 1; }
which helm || { echo "helm not found!"; exit 1; }
helm_version=$(helm version --short)
echo $helm_version | grep -qe "^v3.[5-9]" || { echo "Helm version >= 3.5 required!"; exit 1; }

# Simulate well-known CRDs being available
API_VERSIONS="-a monitoring.coreos.com/v1 -a snapshot.storage.k8s.io/v1"
KUBE_VERSION="--kube-version $(kubectl version -o json | jq -r .serverVersion.gitVersion)"

TMPDIR=$(mktemp -d kubezero.XXX)
[ -z "$DEBUG" ] && trap 'rm -rf $TMPDIR' ERR EXIT


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
    echo "$1 --repo https://cdn.zero-downtime.net/charts"
  else
    echo "$LOCATION/$1"
  fi
}


# make sure namespace exists prior to calling helm as the create-namespace options doesn't work
function create_ns() {
  local namespace=$1
  if [ "$namespace" != "kube-system" ]; then
    kubectl get ns $namespace || kubectl create ns $namespace
  fi
}


# delete non kube-system ns
function delete_ns() {
  local namespace=$1
  [ "$namespace" != "kube-system" ] && kubectl delete ns $namespace
}


# Extract crds via helm calls and apply delta=crds only
function _crds() {
  helm template $(chart_location $chart) -n $namespace --name-template $module $targetRevision --skip-crds --set ${module}.installCRDs=false -f $TMPDIR/values.yaml $API_VERSIONS $KUBE_VERSION > $TMPDIR/helm-no-crds.yaml
  helm template $(chart_location $chart) -n $namespace --name-template $module $targetRevision --include-crds --set ${module}.installCRDs=true -f $TMPDIR/values.yaml $API_VERSIONS $KUBE_VERSION > $TMPDIR/helm-crds.yaml
  diff -e $TMPDIR/helm-no-crds.yaml $TMPDIR/helm-crds.yaml | head -n-1 | tail -n+2 > $TMPDIR/crds.yaml

  # Only apply if there are actually any crds
  if [ -s $TMPDIR/crds.yaml ]; then
    kubectl apply -f $TMPDIR/crds.yaml --server-side
  fi
}


# helm template | kubectl apply -f -
# confine to one namespace if possible
function apply(){
  helm template $(chart_location $chart) -n $namespace --name-template $module $targetRevision --skip-crds -f $TMPDIR/values.yaml $API_VERSIONS $KUBE_VERSION $@ \
    | python3 -c '
#!/usr/bin/python3
import yaml
import sys

for manifest in yaml.safe_load_all(sys.stdin):
    if manifest:
        if "metadata" in manifest and "namespace" not in manifest["metadata"]:
            manifest["metadata"]["namespace"] = sys.argv[1]
        print("---")
        print(yaml.dump(manifest))' $namespace > $TMPDIR/helm.yaml

  kubectl $action -f $TMPDIR/helm.yaml && rc=$? || rc=$?
}


function _helm() {
  local action=$1
  local module=$2

  local chart="kubezero-${module}"
  local namespace="$(yq eval '.spec.destination.namespace' $TMPDIR/kubezero/templates/${module}.yaml)"

  targetRevision=""
  _version="$(yq eval '.spec.source.targetRevision' $TMPDIR/kubezero/templates/${module}.yaml)"

  [ -n "$_version" ] && targetRevision="--version $_version"

  yq eval '.spec.source.helm.values' $TMPDIR/kubezero/templates/${module}.yaml > $TMPDIR/values.yaml

  if [ $action == "crds" ]; then
    # Allow custom CRD handling
    declare -F ${module}-crds && ${module}-crds || _crds

  elif [ $action == "apply" ]; then
    # namespace must exist prior to apply
    create_ns $namespace

    # Optional pre hook
    declare -F ${module}-pre && ${module}-pre

    apply

    # Optional post hook
    declare -F ${module}-post && ${module}-post

  elif [ $action == "delete" ]; then
    apply

    # Delete dedicated namespace if not kube-system
    delete_ns $namespace
  fi

  return 0
}


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


##########
## MAIN ##
##########
if [ ! -f $CLUSTER/kubezero/application.yaml ]; then
  echo "Cannot find cluster config!"
  exit 1
fi

KUBEZERO_VERSION=$(yq eval '.spec.source.targetRevision' $CLUSTER/kubezero/application.yaml)

# Extract all kubezero values from argo app
yq eval '.spec.source.helm.values' $CLUSTER/kubezero/application.yaml > $TMPDIR/values.yaml

# Render all enabled Kubezero modules
helm template $(chart_location kubezero) -f $TMPDIR/values.yaml --version $KUBEZERO_VERSION --devel --output-dir $TMPDIR

# Resolve all the all enabled artifacts
if [ ${ARTIFACTS[0]} == "all" ]; then
  ARTIFACTS=($(ls $TMPDIR/kubezero/templates | sed -e 's/.yaml//g'))
fi
echo "Artifacts: ${ARTIFACTS[@]}"

if [ $1 == "apply" -o $1 == "crds" ]; then
  for t in ${ARTIFACTS[@]}; do
    _helm $1 $t || true
  done

# Delete in reverse order, continue even if errors
elif [ $1 == "delete" ]; then
  set +e
  for (( idx=${#ARTIFACTS[@]}-1 ; idx>=0 ; idx-- )) ; do
    _helm delete ${ARTIFACTS[idx]} || true
  done
fi
