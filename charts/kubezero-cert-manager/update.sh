#!/bin/bash
set -ex

# Fetch dashboards from Grafana.com and update ZDT CM
../kubezero-metrics/sync_grafana_dashboards.py dashboards.yaml templates/grafana-dashboards.yaml

# Get kube-mixin for alerts 
which jsonnet > /dev/null || { echo "Required jsonnet not found!"; exit 1;}
which jb > /dev/null || { echo "Required jb ( json-bundler ) not found!"; exit 1;}

[ -r jsonnetfile.json ] || jb init
if [ -r jsonnetfile.lock.json ]; then
  jb update 
else
  jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@main
  jb install gitlab.com/uneeq-oss/cert-manager-mixin@master
fi

rm -rf rules && mkdir -p rules
jsonnet -J vendor  -m rules rules.jsonnet 

../kubezero-metrics/sync_prometheus_rules.py cert-manager-rules.yaml templates
