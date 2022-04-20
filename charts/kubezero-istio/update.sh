#!/bin/bash
set -ex

export ISTIO_VERSION=$(yq eval '.dependencies[] | select(.name=="base") | .version' Chart.yaml)
export KIALI_VERSION=$(yq eval '.dependencies[] | select(.name=="kiali-server") | .version' Chart.yaml)

helm dep update

# Get matching istioctl
[ -x istioctl ] && [ "$(./istioctl version --remote=false)" == $ISTIO_VERSION ] || { curl -sL https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istioctl-${ISTIO_VERSION}-linux-amd64.tar.gz | tar xz; chmod +x istioctl; }

# Fetch dashboards from Grafana.com and update ZDT CM
../kubezero-metrics/sync_grafana_dashboards.py dashboards.yaml templates/grafana-dashboards.yaml

# Kiali
rm -rf charts/kiali-server
curl -sL https://github.com/kiali/helm-charts/blob/master/docs/kiali-server-${KIALI_VERSION}.tgz?raw=true | tar xz -C charts
