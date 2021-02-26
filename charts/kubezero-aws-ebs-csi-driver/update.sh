#!/bin/bash

VERSION=0.9.10

rm -rf charts/aws-ebs-csi-driver
curl -L -s -o - https://github.com/kubernetes-sigs/aws-ebs-csi-driver/releases/download/helm-chart-aws-ebs-csi-driver-${VERSION}/aws-ebs-csi-driver-${VERSION}.tgz | tar xfz - -C charts

patch -d charts -i ../loglevel_leader.patch -p0
