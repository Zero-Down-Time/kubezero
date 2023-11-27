#!/bin/bash

. ../../scripts/lib-update.sh

update_helm

# Create ZDT dashboard configmap
../kubezero-metrics/sync_grafana_dashboards.py dashboards.yaml templates/grafana-dashboards.yaml

update_docs
