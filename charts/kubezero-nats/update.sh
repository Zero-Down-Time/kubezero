#!/bin/bash
set -ex

# get latest chart until they have upstream repo fixed
rm -rf charts/nats && mkdir -p charts/nats

git clone --depth=1 https://github.com/nats-io/k8s.git
cp -r k8s/helm/charts/nats/* charts/nats/
rm -rf k8s
