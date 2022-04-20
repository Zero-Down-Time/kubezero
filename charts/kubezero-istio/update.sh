#!/bin/bash
set -ex

### TODO
# - https://istio.io/latest/docs/ops/configuration/security/harden-docker-images/

export ISTIO_VERSION=$(yq eval '.dependencies[] | select(.name=="base") | .version' Chart.yaml)
export KIALI_VERSION=$(yq eval '.dependencies[] | select(.name=="kiali-server") | .version' Chart.yaml)

helm dep update

exit 0

# Patch
#exit 0
#diff -tubr istio istio.zdt/
patch -p0 -i zdt.patch --no-backup-if-mismatch

### Create kubezero istio charts

# remove previous charts
rm -rf charts/base charts/istio-*

# create istio main chart
cp -r istio/manifests/charts/base charts/
cp -r istio/manifests/charts/istio-control/istio-discovery charts/

# Create ingress charts
rm -rf ../kubezero-istio-ingress/charts/istio-*
cp -r istio/manifests/charts/gateways/istio-ingress ../kubezero-istio-ingress/charts/
cp -r istio/manifests/charts/gateways/istio-ingress ../kubezero-istio-ingress/charts/istio-private-ingress

# Rename private chart
sed -i -e 's/name: istio-ingress/name: istio-private-ingress/' ../kubezero-istio-ingress/charts/istio-private-ingress/Chart.yaml

# Get matching istioctl
[ -x istioctl ] && [ "$(./istioctl version --remote=false)" == $ISTIO_VERSION ] || { curl -sL https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istioctl-${ISTIO_VERSION}-linux-amd64.tar.gz | tar xz; chmod +x istioctl; }

# Fetch dashboards from Grafana.com and update ZDT CM
../kubezero-metrics/sync_grafana_dashboards.py dashboards.yaml templates/grafana-dashboards.yaml

# Kiali
rm -rf charts/kiali-server
curl -sL https://github.com/kiali/helm-charts/blob/master/docs/kiali-server-${KIALI_VERSION}.tgz?raw=true | tar xz -C charts
