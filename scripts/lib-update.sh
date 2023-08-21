#!/bin/bash
set -ex

#helm repo update

# AWS public ECR
aws ecr-public get-login-password \
     --region us-east-1 | helm registry login \
     --username AWS \
     --password-stdin public.ecr.aws

helm dep update

patch_chart() {
  CHART=$1

  VERSION=$(yq eval '.dependencies[] | select(.name=="'$CHART'") | .version' Chart.yaml)

  rm -rf charts/$CHART
  tar xfvz charts/$CHART-$VERSION.tgz -C charts && rm charts/$CHART-$VERSION.tgz

  # diff -tuNr charts/aws-node-termination-handler.orig charts/aws-node-termination-handler > nth.patch
  patch -p0 -i $CHART.patch --no-backup-if-mismatch
}

update_docs() {
  helm-docs
}
