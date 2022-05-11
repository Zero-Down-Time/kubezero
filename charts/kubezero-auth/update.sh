#!/bin/bash
set -ex

helm dep update

# Operator
VERSION=$(yq eval '.appVersion' Chart.yaml)

wget -q -O crds/keycloak.yaml https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/${VERSION}/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
# No realm imports needed so far
# wget -q -O crds/keycloak-realmimport.yaml https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/${VERSION}/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

wget -q -O templates/keycloak-operator/all.yaml https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/${VERSION}/kubernetes/kubernetes.yml

patch -i keycloak.patch -p0 --no-backup-if-mismatch
