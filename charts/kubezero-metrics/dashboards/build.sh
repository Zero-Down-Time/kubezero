#!/bin/bash

jb update

mkdir -p kube-mixin
jsonnet -J vendor -m kube-mixin -e '(import "mixin.libsonnet").grafanaDashboards'
