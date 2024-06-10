#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

#login_ecr_public
update_helm

# Create ZDT dashboard configmap
../kubezero-metrics/sync_grafana_dashboards.py cilium-dashboards.yaml templates/cilium-grafana-dashboards.yaml
../kubezero-metrics/sync_grafana_dashboards.py haproxy-dashboards.yaml templates/haproxy-grafana-dashboards.yaml

update_docs
