#!/bin/bash

VERSION=16.12.0

rm -rf charts/kube-prometheus-stack
curl -L -s -o - https://github.com/prometheus-community/helm-charts/releases/download/kube-prometheus-stack-${VERSION}/kube-prometheus-stack-${VERSION}.tgz | tar xfz - -C charts

# The grpc alerts could be re-enabled with etcd 3.5
# https://github.com/etcd-io/etcd/pull/12196
patch -p0 -i zdt.patch --no-backup-if-mismatch

# Create ZDT dashboard configmap
cd dashboards
./build.sh
../sync_grafana_dashboards.py metrics-dashboards.yaml ../templates/grafana-dashboards-metrics.yaml
../sync_grafana_dashboards.py k8s-dashboards.yaml ../templates/grafana-dashboards-k8s.yaml
../sync_grafana_dashboards.py zdt-dashboards.yaml ../templates/grafana-dashboards-zdt.yaml
cd -
