#!/bin/bash
set -ex

### Gemini
rm -rf charts/gemini
helm pull fairwinds-stable/gemini --untar --untardir charts
# Patch to run gemini on controller nodes
patch -p0 -i gemini.patch --no-backup-if-mismatch

### EBS
VERSION=$(yq r Chart.yaml dependencies.name==aws-ebs-csi-driver.version)
rm -rf charts/aws-ebs-csi-driver
curl -L -s -o - https://github.com/kubernetes-sigs/aws-ebs-csi-driver/releases/download/helm-chart-aws-ebs-csi-driver-${VERSION}/aws-ebs-csi-driver-${VERSION}.tgz | tar xfz - -C charts
patch -i ebs.patch -p0 --no-backup-if-mismatch


### EFS
VERSION=$(yq r Chart.yaml dependencies.name==aws-efs-csi-driver.version)
rm -rf charts/aws-efs-csi-driver
curl -L -s -o - https://github.com/kubernetes-sigs/aws-efs-csi-driver/releases/download/helm-chart-aws-efs-csi-driver-${VERSION}/aws-efs-csi-driver-${VERSION}.tgz | tar xfz - -C charts
patch -i efs.patch -p0 --no-backup-if-mismatch
