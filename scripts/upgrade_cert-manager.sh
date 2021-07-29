#!/bin/bash

kubectl get -o yaml \
   --all-namespaces \
   issuer,clusterissuer,certificates,certificaterequests > cert-manager-backup.yaml

kubectl cert-manager convert --output-version cert-manager.io/v1 -f cert-manager-backup.yaml > cert-manager-v1.yaml

./bootstrap.sh delete cert-manager $1

kubectl delete crd certificaterequests.cert-manager.io
kubectl delete crd certificates.cert-manager.io
kubectl delete crd challenges.acme.cert-manager.io
kubectl delete crd clusterissuers.cert-manager.io 
kubectl delete crd issuers.cert-manager.io
kubectl delete crd orders.acme.cert-manager.io

./bootstrap.sh crds cert-manager $1
./bootstrap.sh deploy cert-manager $1

kubectl apply -f cert-manager-v1.yaml
