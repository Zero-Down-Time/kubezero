#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

../kubezero-metrics/sync_grafana_dashboards.py dashboards.yaml templates/grafana-dashboards.yaml

#login_ecr_public
update_helm
