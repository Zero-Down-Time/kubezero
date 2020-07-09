#!/bin/bash

# get subchart until they have upstream repo

rm -rf charts/local-volume-provisioner && mkdir -p charts/local-volume-provisioner

git clone --depth=1 https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner.git
cp -r ./sig-storage-local-static-provisioner/helm/provisioner/* charts/local-volume-provisioner

rm -rf sig-storage-local-static-provisioner
