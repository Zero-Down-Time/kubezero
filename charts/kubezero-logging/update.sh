#!/bin/bash

FLUENT_BIT_VERSION=0.15.4
FLUENTD_VERSION=0.2.2

# Fluent Bit
rm -rf charts/fluent-bit
curl -L -s -o - https://github.com/fluent/helm-charts/releases/download/fluent-bit-${FLUENT_BIT_VERSION}/fluent-bit-${FLUENT_BIT_VERSION}.tgz | tar xfz - -C charts

patch -i fluent-bit.patch -p0 --no-backup-if-mismatch


# FluentD
rm -rf charts/fluentd
curl -L -s -o - https://github.com/fluent/helm-charts/releases/download/fluentd-${FLUENTD_VERSION}/fluentd-${FLUENTD_VERSION}.tgz | tar xfz - -C charts

patch -i fluentd.patch -p0 --no-backup-if-mismatch

# Fetch dashboards from Grafana.com and update ZDT CM
../kubezero-metrics/sync_grafana_dashboards.py dashboards.yaml templates/grafana-dashboards.yaml
