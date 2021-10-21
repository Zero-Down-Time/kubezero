KubeZero - Zero Down Time Kubernetes platform
========================
KubeZero is a Kubernetes distribution providing an integrated container platform so you can focus on your applications.

# Design philosophy

- Cloud provider agnostic, bare-metal/self-hosted
- No vendor lock in, most components are optional and could be exchanged
- Organic Open Source / open and permissive licenses over closed-source solutions
- No premium services / subscriptions required
- Staying and contributing back to upstream projects as much as possible


# Version / Support Matrix
KubeZero releases track the same *minor* version of Kubernetes.  
Any 1.20.X-Y release of Kubezero supports any Kubernetes cluster 1.20.X.

KubeZero is distributed as a collection of versioned Helm charts, allowing custom upgrade schedules and module versions as needed.

| KubeZero Version | Kubernetes Version  | EOL         |
|------------------|---------------------|-------------|
| v1.20.8          | v1.20               | 30 Nov 2021 |
| v1.21.0          | v1.21               | 28 Feb 2022 |

[Upstream release policy](https://kubernetes.io/releases/)

# Architecture
![aws_architecture](docs/aws_architecture.png)


# Components

## Container runtime
- cri-o rather than Docker for improved security and performance

## Control plane
- support for single node control plane for small clusters / test environments to reduce costs
- access to control plane from within the VPC only by default ( VPN access required for Admin tasks )
- controller nodes are used for various platform admin controllers / operators to reduce costs and noise on worker nodes

## GitOps
- full ArgoCD support and integration (optional)

## AWS integrations
- IAM roles for service accounts allowing each pod to assume individual IAM roles
- access to meta-data services is blocked all workload containers on all nodes
- system IAM roles are maintained via CloudBender automation

## Network
- Calico using VxLAN incl. increased MTU
- allows flexible / more containers per worker node compated to eg. AWS VPC CNI
- isolates container traffic from VPC by using VxLAN overlay
- no restrictions on IP space / sizing from the underlying VPC architecture

## Storage
- flexible EBS support incl. zone awareness
- EFS support via automated EFS provisioning for worker groups via CloudBender automation
- local storage provider (OpenEBS LVM) for latency sensitive high performance workloads

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
- Various pre-configured Grafana dashboards for common services
- Various pre-configured Alerts
- Alerts can be send via SNSAlertHub to eg. Slack, Goole, Matrix, etc.

## Logging
- all container logs are enhanced with Kubernetes and AWS metadata to provide context for each message
- flexible ElasticSearch setup, leveraging the ECK operator, for easy maintenance & minimal admin knowledge required, incl. automated backups to S3
- Kibana allowing easy search and dashboards for all logs, incl. pre configured index templates and index management
- [fluentd-concerter](https://git.zero-downtime.net/ZeroDownTime/container-park/src/branch/master/fluentd-concenter) service providing queuing during highload as well as additional parsing options
- lightweight fluent-bit agents on each node requiring minimal resources forwarding logs secure via TLS to fluentd-concenter
