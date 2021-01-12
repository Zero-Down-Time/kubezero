#!/bin/bash

# Istio operator resources first
kubectl delete Istiooperators kubezero-istio -n istio-system
kubectl delete Istiooperators kubezero-istio-private-ingress -n istio-system

# Istio operator itself
kubectl delete deployment istio-operator -n istio-operator
kubectl delete ns istio-operator

# Remove policy pod
kubectl delete deployment istio-policy -n istio-system

# Remove old gateways
kubectl delete gateways ingressgateway -n istio-system
kubectl delete gateways private-ingressgateway -n istio-system

# Remove old shared public cert
kubectl delete certificate public-ingress-cert -n istio-system
