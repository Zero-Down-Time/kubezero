KubeZero - Zero Down Time Kubernetes platform
========================
KubeZero is a pre-configured collection of components deployed onto a bare Kubernetes cluster.
All chosen components are 100% organic OpenSource.

# Design goals

- Cloud provider agnostic, bare-metal / self-hosted possible
- No vendor lock in
- No closed source solutions
- No premium services / subscriptions required
- Staying to upstream projects as close as possible
- Minimal custom code
- Work within each community / give back


# Components

## Network / CNI
- Calico using VxLAN as default backend

## Certificate management
- cert-manager incl. a local self-signed cluster CA

## Metrics / Alerting
- Prometheus / Grafana

## Logging
- Fluent-bit 
- Fluentd
- ElasticSearch
- Kibana

## Dashboard 
- see ArgoCD

## Storage
- EBS external CSI storage provider
- EFS external CSI storage provider
- LocalVolumes
- LocalPath

## Ingress 
- AWS Network Loadbalancer
- Istio providing Public and Private Envoy proxies
- HTTP(s) and TCP support
- Real client source IPs available

## Service Mesh ( optional )


# KubeZero vs. EKS

## Controller nodes used for various admin controllers

## KIAM incl. blocked access to meta-data service

