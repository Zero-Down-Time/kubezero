#!/bin/bash
set -ex

LOCATION=${1:-""}

DEPLOY_DIR=$( dirname $( realpath $0 ))

function chart_location() {
  if [ -z "$LOCATION" ]; then
    echo "$1 --repo https://zero-down-time.github.io/kubezero"
  else
    echo "$LOCATION/$1"
  fi
}

# Update only if we use upstream
if [ -z "$LOCATION" ]; then
  helm repo add kubezero https://zero-down-time.github.io/kubezero
  helm repo update
fi

TMPDIR=$(mktemp -d kubezero.XXX)

# This will be stored as secret during the initial kubezero chart install
helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml > $TMPDIR/kubezero.yaml

helm template $(chart_location kubezero) --namespace argocd --name-template kubezero --skip-crds -f $TMPDIR/kubezero.yaml > $TMPDIR/helm.yaml
kubectl apply --namespace argocd -f $TMPDIR/helm.yaml

[ "$DEBUG" == "" ] && rm -rf $TMPDIR
