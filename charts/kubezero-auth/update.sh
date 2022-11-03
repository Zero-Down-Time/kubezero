#!/bin/bash

# https://www.keycloak.org/operator/installation 

set -ex

helm dep update

# Operator
VERSION=$(yq eval '.appVersion' Chart.yaml)

wget -O crds/keycloak.yaml https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/"${VERSION}"/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
wget -O crds/keycloak-realmimports.yaml https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/"${VERSION}"/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

wget -O templates/keycloak/operator.yaml https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/"${VERSION}"/kubernetes/kubernetes.yml
patch -i keycloak.patch -p0 --no-backup-if-mismatch
