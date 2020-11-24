#!/bin/bash
set -ex

export ISTIO_VERSION=1.8.0

if [ ! -d istio-$ISTIO_VERSION ]; then
  NAME="istio-$ISTIO_VERSION"
  URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-amd64.tar.gz"

  curl -sL "$URL" | tar xz
fi

# Extract control plane charts 
rm -rf charts/base charts/istio-*
cp -r istio-${ISTIO_VERSION}/manifests/charts/base charts/
cp -r istio-${ISTIO_VERSION}/manifests/charts/istio-control/istio-discovery charts/

# Patch for istiod to control plane
patch -p3 -i istio-discovery.patch

# Minor tweaks
rm -f charts/istio-discovery/templates/telemetryv2_1.[67].yaml

# Ingress charts
rm -rf ../kubezero-istio-ingress/charts/istio-*
cp -r istio-${ISTIO_VERSION}/manifests/charts/gateways/istio-ingress ../kubezero-istio-ingress/charts/
cp -r istio-${ISTIO_VERSION}/manifests/charts/gateways/istio-ingress ../kubezero-istio-ingress/charts/istio-private-ingress

# Rename private chart
sed -i -e 's/name: istio-ingress/name: istio-private-ingress/' ../kubezero-istio-ingress/charts/istio-private-ingress/Chart.yaml

# Get matching istioctl
# [ -x istioctl ] && [ "$(./istioctl version --remote=false)" == $ISTIO_VERSION ] || { curl -sL https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istioctl-${ISTIO_VERSION}-linux-amd64.tar.gz | tar xz; chmod +x istioctl; }
