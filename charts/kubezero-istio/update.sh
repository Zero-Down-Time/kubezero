#!/bin/bash
set -ex

ISTIO_VERSION=1.6.5

NAME="istio-$ISTIO_VERSION"
URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-amd64.tar.gz"

curl -sL "$URL" | tar xz

# Now lets extract what we need
rm -rf charts/istio-operator
cp -r istio-${ISTIO_VERSION}/manifests/charts/istio-operator charts

rm -rf istio-${ISTIO_VERSION}

# Apply our patch
patch  -i istio-operator.patch -p3

# Extract base / CRDs from istioctl into plain manifest to workaround chicken egg problem with CRDs
istioctl manifest generate --set profile=empty --set components.base.enabled=true > templates/istio-base.yaml
