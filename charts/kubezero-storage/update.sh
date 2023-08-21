#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

#login_ecr_public
update_helm

patch_chart gemini

patch_chart aws-ebs-csi-driver
rm -rf charts/aws-ebs-csi-driver/templates/tests

patch_chart aws-efs-csi-driver

patch_chart lvm-localpv
# move snapshotclasses/content from lvm-localpv to toplevel
mv charts/lvm-localpv/templates/*crd.yaml templates/snapshot-controller

# k8up - CRDs
VERSION=$(yq eval '.dependencies[] | select(.name=="k8up") | .version' Chart.yaml)
curl -L -s -o crds/k8up.yaml https://github.com/k8up-io/k8up/releases/download/k8up-${VERSION}/k8up-crd.yaml

# Metrics
cd jsonnet
make render

update_docs
