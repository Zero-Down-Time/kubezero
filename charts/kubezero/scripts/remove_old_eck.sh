#!/usr/bin/env bash

# Copyright Elasticsearch B.V. and/or licensed to Elasticsearch B.V. under one
# or more contributor license agreements. Licensed under the Elastic License;
# you may not use this file except in compliance with the Elastic License.

# Script to migrate an existing ECK 1.2.1 installation to Helm. 

set -euo pipefail

RELEASE_NAMESPACE=${RELEASE_NAMESPACE:-"elastic-system"}

echo "Uninstalling ECK"
kubectl delete -n "${RELEASE_NAMESPACE}" \
    serviceaccount/elastic-operator \
    secret/elastic-webhook-server-cert \
    clusterrole.rbac.authorization.k8s.io/elastic-operator \
    clusterrole.rbac.authorization.k8s.io/elastic-operator-view \
    clusterrole.rbac.authorization.k8s.io/elastic-operator-edit \
    clusterrolebinding.rbac.authorization.k8s.io/elastic-operator \
    rolebinding.rbac.authorization.k8s.io/elastic-operator \
    service/elastic-webhook-server \
    statefulset.apps/elastic-operator \
    validatingwebhookconfiguration.admissionregistration.k8s.io/elastic-webhook.k8s.elastic.co

