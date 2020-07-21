#!/bin/bash

# First delete old 1.4 
kubectl delete -f ingress-gateway.yaml
kubectl delete -f istio.yaml
kubectl delete -f istio-init.yaml
kubectl delete -f namespace.yaml

# Now we need to install the new Istio Operator via KubeZero

# deploy the CR for 1.6
kubectl apply -f istio-1.6.yaml

# add the additiona private ingress gateway as dedicated CR
kubectl apply -f istio-1.6-private-ingress.yaml
