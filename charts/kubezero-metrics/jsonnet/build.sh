#!/bin/bash -ex

which jsonnet > /dev/null || { echo "Required jsonnet not found!"; exit 1;}
which jb > /dev/null || { echo "Required jb ( json-bundler ) not found!"; exit 1;}

# wget https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v0.4.0/jb-linux-amd64

[ -r jsonnetfile.json ] || jb init
if [ -r jsonnetfile.lock.json ]; then
  jb update
else
  #jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@main
  jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@release-0.11
fi
