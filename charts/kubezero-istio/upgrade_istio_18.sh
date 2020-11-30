#!/bin/bash

# Remove operator first
kubectl delete deployment istio-operator -n istio-operator
kubectl delete ns istio-operator

# Remove policy
kubectl delete deployment istio-policy -n istio-system

# Install new istio and istio-ingress chart

# Remobe old ingress
kubectl delete deployment istio-ingressgateway -n istio-system
kubectl delete deployment istio-private-ingressgateway -n istio-system
