#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

#login_ecr_public
update_helm

# Create ZDT dashboard configmap
../kubezero-metrics/sync_grafana_dashboards.py dashboard-jenkins.yaml templates/jenkins/grafana-dashboard.yaml
../kubezero-metrics/sync_grafana_dashboards.py dashboard-gitea.yaml templates/gitea/grafana-dashboard.yaml

update_docs
