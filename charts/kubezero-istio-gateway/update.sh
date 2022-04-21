#!/bin/bash
set -ex

export ISTIO_VERSION=$(yq eval '.dependencies[] | select(.name=="gateway") | .version' Chart.yaml)

helm dep update

# Patch
tar xf charts/gateway-$ISTIO_VERSION.tgz -C charts && rm -f charts/gateway-$ISTIO_VERSION.tgz
#diff -tubr charts/gateway.orig charts/gateway
patch -p0 -i zdt.patch --no-backup-if-mismatch
