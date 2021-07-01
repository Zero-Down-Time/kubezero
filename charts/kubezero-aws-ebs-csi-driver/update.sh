#!/bin/bash

VERSION=1.2.3

rm -rf charts/aws-ebs-csi-driver
curl -L -s -o - https://github.com/kubernetes-sigs/aws-ebs-csi-driver/releases/download/helm-chart-aws-ebs-csi-driver-${VERSION}/aws-ebs-csi-driver-${VERSION}.tgz | tar xfz - -C charts

patch -i zdt.patch -p0 --no-backup-if-mismatch
