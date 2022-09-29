#!/bin/bash

# Simulate well-known CRDs being available
API_VERSIONS="-a monitoring.coreos.com/v1 -a snapshot.storage.k8s.io/v1"

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
  echo "$1 --repo https://cdn.zero-downtime.net/charts"
}


function argo_used() {
  kubectl get application kubezero -n argocd >/dev/null && rc=$? || rc=$?
  return $rc
}


# get kubezero-values from ArgoCD if available or use in-cluster CM without Argo
function get_kubezero_values() {
  argo_used && \
    { kubectl get application kubezero -n argocd -o yaml | yq .spec.source.helm.values > ${WORKDIR}/kubezero-values.yaml; } || \
    { kubectl get configmap -n kube-system kubezero-values -o yaml | yq '.data."values.yaml"' > ${WORKDIR}/kubezero-values.yaml ;}
}


function disable_argo() {
  cat > _argoapp_patch.yaml <<EOF
spec:
  syncWindows:
    - kind: deny
      schedule: '0 * * * *'
      duration: 24h
      namespaces:
      - '*'
EOF
  kubectl patch appproject kubezero -n argocd --patch-file _argoapp_patch.yaml --type=merge && rm _argoapp_patch.yaml
  echo "Enabled service window for ArgoCD project kubezero"
}


function enable_argo() {
  kubectl patch appproject kubezero -n argocd --type json -p='[{"op": "remove", "path": "/spec/syncWindows"}]' || true
  echo "Removed service window for ArgoCD project kubezero"
}


function cntFailedPods() {
  NS=$1

  NR=$(kubectl get pods -n $NS --field-selector="status.phase!=Succeeded,status.phase!=Running" -o custom-columns="POD:metadata.name" -o json | jq '.items | length')
  echo $NR
}


function waitSystemPodsRunning() {
  while true; do
    [ "$(cntFailedPods kube-system)" -eq 0 ] && break
    sleep 3
  done
}

function argo_app_synced() {
  APP=$1

  # Ensure we are synced otherwise bail out
  status=$(kubectl get application $APP -n argocd -o yaml | yq .status.sync.status)
  if [ "$status" != "Synced" ]; then
    echo "ArgoCD Application $APP not 'Synced'!"
    return 1
  fi

  return 0
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
  helm template $(chart_location $chart) -n $namespace --name-template $module $targetRevision --skip-crds --set ${module}.installCRDs=false -f $WORKDIR/values.yaml $API_VERSIONS --kube-version $KUBE_VERSION > $WORKDIR/helm-no-crds.yaml
  helm template $(chart_location $chart) -n $namespace --name-template $module $targetRevision --include-crds --set ${module}.installCRDs=true -f $WORKDIR/values.yaml $API_VERSIONS --kube-version $KUBE_VERSION > $WORKDIR/helm-crds.yaml
  diff -e $WORKDIR/helm-no-crds.yaml $WORKDIR/helm-crds.yaml | head -n-1 | tail -n+2 > $WORKDIR/crds.yaml

  # Only apply if there are actually any crds
  if [ -s $WORKDIR/crds.yaml ]; then
    kubectl apply -f $WORKDIR/crds.yaml --server-side --force-conflicts
  fi
}


# helm template | kubectl apply -f -
# confine to one namespace if possible
function apply() {
  helm template $(chart_location $chart) -n $namespace --name-template $module $targetRevision --skip-crds -f $WORKDIR/values.yaml $API_VERSIONS --kube-version $KUBE_VERSION $@ \
    | python3 -c '
#!/usr/bin/python3
import yaml
import sys

for manifest in yaml.safe_load_all(sys.stdin):
    if manifest:
        if "metadata" in manifest and "namespace" not in manifest["metadata"]:
            manifest["metadata"]["namespace"] = sys.argv[1]
        print("---")
        print(yaml.dump(manifest))' $namespace > $WORKDIR/helm.yaml

  kubectl $action -f $WORKDIR/helm.yaml --server-side --force-conflicts && rc=$? || rc=$?
}


function _helm() {
  local action=$1
  local module=$2

  # check if module is even enabled and return if not
  [ ! -f $WORKDIR/kubezero/templates/${module}.yaml ] && { echo "Module $module disabled. No-op."; return 0; }

  local chart="$(yq eval '.spec.source.chart' $WORKDIR/kubezero/templates/${module}.yaml)"
  local namespace="$(yq eval '.spec.destination.namespace' $WORKDIR/kubezero/templates/${module}.yaml)"

  targetRevision=""
  _version="$(yq eval '.spec.source.targetRevision' $WORKDIR/kubezero/templates/${module}.yaml)"

  [ -n "$_version" ] && targetRevision="--version $_version"

  yq eval '.spec.source.helm.values' $WORKDIR/kubezero/templates/${module}.yaml > $WORKDIR/values.yaml

  echo "using values to $action of module $module: "
  cat $WORKDIR/values.yaml

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
    [ -n "$DELETE_NS" ] && delete_ns $namespace
  fi

  return 0
}
