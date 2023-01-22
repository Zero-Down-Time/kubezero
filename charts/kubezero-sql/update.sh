#!/bin/bash
set -ex

helm dep update

### MariaDB

# Fetch dashboards
../kubezero-metrics/sync_grafana_dashboards.py dashboards-mariadb.yaml templates/mariadb/grafana-dashboards.yaml
