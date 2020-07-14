#!/bin/bash
set -ex

ISTIO_VERSION=1.5.8

NAME="istio-$ISTIO_VERSION"
URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux.tar.gz"

curl -sL "$URL" | tar xz

# Now lets extract what we need
rm -rf charts/istio-operator
cp -r istio-${ISTIO_VERSION}/install/kubernetes/operator/charts/istio-operator charts

rm -rf istio-${ISTIO_VERSION}
