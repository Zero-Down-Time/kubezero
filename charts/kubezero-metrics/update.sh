#!/bin/bash

VERSION=14.3.0

rm -rf charts/kube-prometheus-stack
curl -L -s -o - https://github.com/prometheus-community/helm-charts/releases/download/kube-prometheus-stack-${VERSION}/kube-prometheus-stack-${VERSION}.tgz | tar xfz - -C charts

patch -p3 -i remove_etcd_grpc_alerts.patch --no-backup-if-mismatch
