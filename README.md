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


## General
- Container runtime cri-o rather than Docker for improved security and performance


## Control plane
- support for single node control plane for small clusters / test environments to reduce costs
- access to control plane from within the VPC only by default ( VPN access required for Admin tasks )
- controller nodes are used for various platform admin controllers / operators to reduce costs and noise on worker nodes
- integrated ArgoCD Gitops controller

## AWS IAM access control
- Kiam allowing IAM roles per pod
- IAM roles are assumed / requested and cached on controller nodes for improved security
- blocking access to meta-data service on all nodes
- IAM roles are maintained/ automated and tracked via CFN templates

## Network
- Calico using VxLAN incl. increased MTU
- allows way more containers per worker
- isolates container traffic from VPC by using VxLAN overlay
- no restrictions on IP space / sizing from the underlying VPC architecture

## Storage
- flexible EBS support incl. zone awareness
- EFS support via automated EFS provisioning for worker groups via CFN templates
- local storage provider for latency sensitive high performance workloads

## Ingress
- AWS Network Loadbalancer and Istio Ingress controllers
- No additional costs per exposed service
- Automated SSL Certificate handling via cert-manager incl. renewal etc.
- support for TCP services
- Client source IP available to workloads via HTTP header
- optional full service mesh

## Metrics
- Prometheus support for all components
- automated service discovery allowing instant access to common workload metrics
- Preconfigured community maintained Grafana dashboards for common services
- Preconfigured community maintained Alerts

## Logging
- all container logs are enhanced with Kubernetes metadata to provide context for each message
- flexible ElasticSearch setup via ECK operator to ease maintenance and reduce required admin knowledge, incl automated backups to S3
- Kibana allowing easy search and dashboards for all logs, incl. pre configured index templates and index management to reduce costs
- fluentd central log ingress service allowing additional parsing and queuing to improved reliability
- lightweight fluent-bit agents on each node requiring minimal resources forwarding logs secure via SSL to fluentd
