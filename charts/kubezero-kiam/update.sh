#!/bin/bash
set -ex

# Fetch dashboards
../kubezero-metrics/sync_grafana_dashboards.py dashboards.yaml templates/grafana-dashboards.yaml
