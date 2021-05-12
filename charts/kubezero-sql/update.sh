#!/bin/bash
set -ex

### MariaDB


# Fetch dashboards
../kubezero-metrics/sync_grafana_dashboards.py dashboards-mariadb.yaml templates/mariadb/grafana-dashboards.yaml
