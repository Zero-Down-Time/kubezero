#!/bin/bash
set -ex

VERSION=$(yq eval '.dependencies[] | select(.name=="kube-prometheus-stack") | .version' Chart.yaml)
PG_VER=$(yq eval '.dependencies[] | select(.name=="prometheus-pushgateway") | .version' Chart.yaml)

rm -rf charts/kube-prometheus-stack
helm pull prometheus-community/kube-prometheus-stack --untar --untardir charts --version $VERSION

rm -rf charts/prometheus-pushgateway
helm pull prometheus-community/prometheus-pushgateway --untar --untardir charts --version $PG_VER

# workaround for https://github.com/prometheus-community/helm-charts/issues/1500
patch -p0 -i zdt.patch --no-backup-if-mismatch

patch -p0 -i zdt-pushgateway.patch --no-backup-if-mismatch

# Create ZDT dashboard, alerts etc configmaps
cd jsonnet && make

../sync_grafana_dashboards.py metrics-dashboards.yaml ../templates/grafana-dashboards-metrics.yaml
../sync_grafana_dashboards.py k8s-dashboards.yaml ../templates/grafana-dashboards-k8s.yaml
../sync_grafana_dashboards.py zdt-dashboards.yaml ../templates/grafana-dashboards-zdt.yaml

../sync_prometheus_rules.py k8s-rules.yaml ../templates/rules
cd -

# Delete not used upstream dashboards or rules
rm -rf charts/kube-prometheus-stack/templates/grafana/dashboards-1.14 charts/kube-prometheus-stack/templates/prometheus/rules-1.14
