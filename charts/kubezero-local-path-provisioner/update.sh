#!/bin/bash

# get subchart until they have upstream repo
rm -rf charts/local-path-provisioner && mkdir -p charts/local-path-provisioner

git clone --depth=1 https://github.com/rancher/local-path-provisioner.git
cp -r local-path-provisioner/deploy/chart/* charts/local-path-provisioner
rm -rf local-path-provisioner
