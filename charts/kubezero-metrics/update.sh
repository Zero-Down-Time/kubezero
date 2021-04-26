#!/bin/bash

VERSION=15.2.0

rm -rf charts/kube-prometheus-stack
curl -L -s -o - https://github.com/prometheus-community/helm-charts/releases/download/kube-prometheus-stack-${VERSION}/kube-prometheus-stack-${VERSION}.tgz | tar xfz - -C charts

# The grpc alerts could be re-enabled with etcd 3.5
# https://github.com/etcd-io/etcd/pull/12196
patch -p0 -i metrics-zdt.patch --no-backup-if-mismatch

# Create ZDT dashboard configmap
./sync_grafana_dashboards.py dashboards/kube-mixin.yaml templates/grafana-dashboards.yaml
