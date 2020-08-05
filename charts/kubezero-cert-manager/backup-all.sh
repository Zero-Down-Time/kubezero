#!/bin/bash

kubectl get -A -o yaml issuer,clusterissuer,certificates,certificaterequests > cert-manager-backup.yaml
echo '---' >> cert-manager-backup.yaml
kubectl get -A -o yaml secrets --field-selector type=kubernetes.io/tls >> cert-manager-backup.yaml
echo '---' >> cert-manager-backup.yaml
kubectl get -o yaml secrets -n cert-manager letsencrypt-dns-prod >> cert-manager-backup.yaml
