#!/bin/bash
set -ex

# prometheus metrics mixin branch
# https://github.com/prometheus-operator/kube-prometheus#compatibility
KUBE_PROMETHEUS_RELEASE=main

update_jsonnet() {
  which jsonnet > /dev/null || { echo "Required jsonnet not found!"; exit 1;}
  which jb > /dev/null || { echo "Required jb ( json-bundler ) not found!"; exit 1;}

  # remove previous versions
  rm -f jsonnetfile.json jsonnetfile.lock.json

  jb init
  jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@main
}

update_helm() {
  #helm repo update
  helm dep update
}

# AWS public ECR
login_ecr_public() {
  aws ecr-public get-login-password \
    --region us-east-1 | helm registry login \
    --username AWS \
    --password-stdin public.ecr.aws
}

patch_chart() {
  CHART=$1

  VERSION=$(yq eval '.dependencies[] | select(.name=="'$CHART'") | .version' Chart.yaml)

  rm -rf charts/$CHART
  tar xfvz charts/$CHART-$VERSION.tgz -C charts && rm charts/$CHART-$VERSION.tgz

  # diff -tuNr charts/aws-node-termination-handler.orig charts/aws-node-termination-handler > nth.patch
  [ -r $CHART.patch ] && patch -p0 -i $CHART.patch --no-backup-if-mismatch || true
}

update_docs() {
  helm-docs
}
