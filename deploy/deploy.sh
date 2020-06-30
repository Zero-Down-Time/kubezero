#!/bin/bash
set -ex

DEPLOY_DIR=$( dirname $( realpath $0 ))

helm repo add kubezero https://zero-down-time.github.io/kubezero
helm repo update

# Determine if we bootstrap or update
helm list -n argocd -f kubezero -q | grep -q kubezero && rc=$? || rc=$?
if [ $rc -eq 0 ]; then
  helm template $DEPLOY_DIR -f values.yaml -f kubezero.yaml > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
else
  # During bootstrap we first generate a minimal values.yaml to prevent various deadlocks
  helm template $DEPLOY_DIR -f values.yaml -f kubezero.yaml --set=bootstrap=true > generated-values.yaml
  helm install -n argocd kubezero kubezero/kubezero-argo-cd --create-namespace -f generated-values.yaml
fi
