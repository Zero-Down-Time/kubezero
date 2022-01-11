#!/bin/bash
set -ex

### Gemini
rm -rf charts/gemini
helm pull fairwinds-stable/gemini --untar --untardir charts
# Patch to run gemini on controller nodes
patch -p0 -i gemini.patch --no-backup-if-mismatch

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
patch -i ebs.patch -p0 --no-backup-if-mismatch

### EFS
VERSION=$(yq eval '.dependencies[] | select(.name=="aws-efs-csi-driver") | .version' Chart.yaml)
rm -rf charts/aws-efs-csi-driver
curl -L -s -o - https://github.com/kubernetes-sigs/aws-efs-csi-driver/releases/download/helm-chart-aws-efs-csi-driver-${VERSION}/aws-efs-csi-driver-${VERSION}.tgz | tar xfz - -C charts
patch -i efs.patch -p0 --no-backup-if-mismatch
