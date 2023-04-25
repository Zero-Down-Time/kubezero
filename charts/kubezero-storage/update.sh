#!/bin/bash
set -ex

helm dependencies update

### Gemini
rm -rf charts/gemini
helm pull fairwinds-stable/gemini --untar --untardir charts
# Patch to run gemini on controller nodes
patch -p0 -i gemini.patch --no-backup-if-mismatch

# k8up
VERSION=$(yq eval '.dependencies[] | select(.name=="k8up") | .version' Chart.yaml)
curl -L -s -o crds/k8up.yaml https://github.com/k8up-io/k8up/releases/download/k8up-${VERSION}/k8up-crd.yaml

### openEBS
VERSION=$(yq eval '.dependencies[] | select(.name=="lvm-localpv") | .version' Chart.yaml)
helm repo add openebs-lvmlocalpv https://openebs.github.io/lvm-localpv || true
rm -rf charts/lvm-localpv
helm pull openebs-lvmlocalpv/lvm-localpv --version $VERSION --untar --untardir charts
mv charts/lvm-localpv/crds/volumesnapshot* crds
patch -i lvm.patch -p0 --no-backup-if-mismatch

### EBS
VERSION=$(yq eval '.dependencies[] | select(.name=="aws-ebs-csi-driver") | .version' Chart.yaml)
rm -rf charts/aws-ebs-csi-driver
curl -L -s -o - https://github.com/kubernetes-sigs/aws-ebs-csi-driver/releases/download/helm-chart-aws-ebs-csi-driver-${VERSION}/aws-ebs-csi-driver-${VERSION}.tgz | tar xfz - -C charts
rm -rf charts/aws-ebs-csi-driver/templates/test

### EFS
VERSION=$(yq eval '.dependencies[] | select(.name=="aws-efs-csi-driver") | .version' Chart.yaml)
rm -rf charts/aws-efs-csi-driver
curl -L -s -o - https://github.com/kubernetes-sigs/aws-efs-csi-driver/releases/download/helm-chart-aws-efs-csi-driver-${VERSION}/aws-efs-csi-driver-${VERSION}.tgz | tar xfz - -C charts
patch -i efs.patch -p0 --no-backup-if-mismatch

# Metrics
cd jsonnet
make render

helm-docs
