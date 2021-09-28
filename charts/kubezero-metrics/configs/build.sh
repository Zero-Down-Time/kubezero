#!/bin/bash -ex

JB='./jb-linux-amd64'

which jsonnet > /dev/null || { echo "Required jsonnet not found!"; }
[ -x $JB ] || { wget https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v0.4.0/jb-linux-amd64 && chmod +x $JB; }
#which gojsontoyaml || go install github.com/brancz/gojsontoyaml@latest

[ -r jsonnetfile.json ] || $JB init
if [ -r jsonnetfile.lock.json ]; then
  $JB update 
else
  $JB install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@main
fi

rm -rf dashboards && mkdir -p dashboards
jsonnet -J vendor -m dashboards -e '(import "mixin.libsonnet").grafanaDashboards'

rm -rf rules && mkdir -p rules
#jsonnet -J vendor -m rules rules.libsonnet | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml' -- {}
jsonnet -J vendor -m rules rules.libsonnet
