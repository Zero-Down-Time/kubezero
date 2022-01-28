#!/bin/bash
set -ex

NTH_VERSION=$(yq eval '.dependencies[] | select(.name=="aws-node-termination-handler") | .version' Chart.yaml)

# Disabled until these AWS "pros" bump the chart number
#rm -rf charts/aws-node-termination-handler
#helm pull eks/aws-node-termination-handler --untar --untardir charts --version $NTH_VERSION

# diff -tuNr charts/aws-node-termination-handler.orig charts/aws-node-termination-handler > nth.patch
patch -p0 -i nth.patch --no-backup-if-mismatch
