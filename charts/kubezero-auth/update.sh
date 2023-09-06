#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

login_ecr_public
update_helm

# Fetch dashboards
../kubezero-metrics/sync_grafana_dashboards.py dashboards-keycloak.yaml templates/keycloak/grafana-dashboards.yaml

update_docs
