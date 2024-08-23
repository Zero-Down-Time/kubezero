##!/bin/bash
set -ex

. ../../scripts/lib-update.sh

#login_ecr_public
update_helm

# Fetch dashboards
../kubezero-metrics/sync_grafana_dashboards.py dashboards-nats.yaml templates/nats/grafana-dashboards.yaml
../kubezero-metrics/sync_grafana_dashboards.py dashboards-rabbitmq.yaml templates/rabbitmq/grafana-dashboards.yaml

update_docs
