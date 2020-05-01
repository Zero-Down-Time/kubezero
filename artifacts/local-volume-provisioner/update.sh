#!/bin/bash

# get chart and render yaml
git clone --depth=1 https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner.git
helm template  ./sig-storage-local-static-provisioner/helm/provisioner -f values.yaml --namespace kube-system > local-volume-provisioner.yaml
