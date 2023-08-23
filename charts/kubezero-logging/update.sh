#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

ECK_VERSION=$(yq eval '.dependencies[] | select(.name=="eck-operator") | .version' Chart.yaml)
FLUENT_BIT_VERSION=$(yq eval '.dependencies[] | select(.name=="fluent-bit") | .version' Chart.yaml)
FLUENTD_VERSION=$(yq eval '.dependencies[] | select(.name=="fluentd") | .version' Chart.yaml)

patch_chart eck-operator

# fix ECK crds handling to adhere to proper helm v3 support which also fixes ArgoCD applying updates on upgrades
mkdir charts/eck-operator/crds
helm template charts/eck-operator/charts/eck-operator-crds --name-template logging --kube-version 1.26 > charts/eck-operator/crds/all-crds.yaml

rm -rf charts/eck-operator/charts
yq eval -Mi 'del(.dependencies)' charts/eck-operator/Chart.yaml

# fluent-bit
patch_chart fluent-bit

# FluentD
patch_chart fluentd
rm -f charts/fluentd/templates/files.conf/systemd.yaml

# Fetch dashboards from Grafana.com and update ZDT CM
../kubezero-metrics/sync_grafana_dashboards.py dashboards.yaml templates/fluent-bit/grafana-dashboards.yaml
../kubezero-metrics/sync_grafana_dashboards.py dashboards-es.yaml templates/eck/grafana-dashboards.yaml
