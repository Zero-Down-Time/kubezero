#!/bin/bash

VERSION=1.2.1

rm -rf charts/aws-efs-csi-driver
curl -L -s -o - https://github.com/kubernetes-sigs/aws-efs-csi-driver/releases/download/helm-chart-aws-efs-csi-driver-${VERSION}/aws-efs-csi-driver-${VERSION}.tgz | tar xfz - -C charts

patch -i affinity_resources.patch -p0 --no-backup-if-mismatch
