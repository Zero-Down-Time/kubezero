#!/bin/bash
set -ex

helm repo update

NTH_VERSION=$(yq eval '.dependencies[] | select(.name=="aws-node-termination-handler") | .version' Chart.yaml)
RUH_VERSION=$(yq eval '.dependencies[] | select(.name=="aws-eks-asg-rolling-update-handler") | .version' Chart.yaml)

rm -rf charts/aws-node-termination-handler
helm pull eks/aws-node-termination-handler --untar --untardir charts --version $NTH_VERSION

# diff -tuNr charts/aws-node-termination-handler.orig charts/aws-node-termination-handler > nth.patch
patch -p0 -i nth.patch --no-backup-if-mismatch

rm -rf charts/aws-eks-asg-rolling-update-handler
helm pull twin/aws-eks-asg-rolling-update-handler --untar --untardir charts --version $RUH_VERSION
patch -p0 -i ruh.patch --no-backup-if-mismatch

helm dep update
