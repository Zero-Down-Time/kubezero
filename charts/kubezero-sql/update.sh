#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

#login_ecr_public
update_helm

### MariaDB

# Fetch dashboards
../kubezero-metrics/sync_grafana_dashboards.py dashboards-mariadb.yaml templates/mariadb/grafana-dashboards.yaml

update_docs

