#!/bin/bash

# First delete old 1.4 
kubectl delete -f ingress-gateway.yaml
kubectl delete -f istio.yaml
kubectl delete -f istio-init.yaml
kubectl delete -f namespace.yaml
