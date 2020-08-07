#!/bin/bash

[ -f istio-authorization-policy.yaml ] && kubectl delete -f istio-authorization-policy.yaml
[ -f istio-service.yaml ] && kubectl delete -f istio-service.yaml

kubectl delete -f manifests
kubectl delete -f manifests/setup

kubectl delete namespace monitoring
