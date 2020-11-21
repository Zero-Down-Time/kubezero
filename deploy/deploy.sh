#!/bin/bash
set -e

DEPLOY_DIR=$( dirname $( realpath $0 ))

helm repo add kubezero https://zero-down-time.github.io/kubezero
helm repo update

# Determine if we bootstrap or update
helm list -n argocd -f kubezero -q | grep -q kubezero && rc=$? || rc=$?
if [ $rc -eq 0 ]; then
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
else
  echo "To bootstrap clusters please use bootstrap.sh !"
  exit 1
fi
