#!/bin/bash

FLUENT_BIT_VERSION=0.12.3

rm -rf charts/fluent-bit
curl -L -s -o - https://github.com/fluent/helm-charts/releases/download/fluent-bit-${FLUENT_BIT_VERSION}/fluent-bit-${FLUENT_BIT_VERSION}.tgz | tar xfz - -C charts

patch -i fluent-bit.patch -p0 --no-backup-if-mismatch
