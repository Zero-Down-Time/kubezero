#!/bin/bash
set -ex

export ISTIO_VERSION=1.7.3

if [ ! -d istio-$ISTIO_VERSION ]; then
  NAME="istio-$ISTIO_VERSION"
  URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-amd64.tar.gz"

  curl -sL "$URL" | tar xz
fi

# Now lets extract what we need
rm -rf charts/istio-operator
cp -r istio-${ISTIO_VERSION}/manifests/charts/istio-operator charts

# Apply our patch
patch  -i istio-operator.patch -p0

[ -x istioctl ] || { curl -sL https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istioctl-${ISTIO_VERSION}-linux-amd64.tar.gz | tar xz; chmod +x istioctl; }

# Extract base / CRDs from istioctl into plain manifest to workaround chicken egg problem with CRDs
./istioctl manifest generate --set profile=empty --set components.base.enabled=true > templates/istio-base.yaml

# Remove double CRD
patch  -i istio-base.patch -p3
