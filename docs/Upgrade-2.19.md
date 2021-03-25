# Upgrade to KubeZero V2.19.0

# CloudBender / Kubernetes v1.19
## Changes
- worker nodes names are now the default AWS private hostnames, rather than the CloudBender provided unique static hostnames :-(  
This change was required to enable node restrictions via the upstream aws-iam-authenticator as well as prepare for support of the Horizontal Autoscaler and Spot Instances in the next releases 
- cluster-admin kubectl config now stored on SSM Parameter store, contains no more secrets leveraging IAM roles
- fully encrypted cluster backup on S3
( automated migration and cleanup of previous files )
- backup password and cluster version stored on SSM Parameter store
- worker nodes authenticate via IAM roles rather than tokens
- improved resource reservations on all nodes
- various security / reliability improvements and bug fixes
 
## Upgrade
- Set Kubernetes version in the controller config to eg. `1.19`  
- Update controller and worker stacks with latest CFN code

- terminate controller00 first, afterwards remaining controllers
- replace worker nodes in a rolling fashion via. drain / terminate / rinse-repeat

# KubeZero
## Changes
- Version bump to latest releases of *EVERY* component
- optional support for fuse-device-plugin
- KubeZero now supports bare-metal, all AWS components optional
- resource definitions for most admin pods, incl. apiserver, etcd, etc.
- Logging:
  - ES resources are now defined using standard config vs. custom settings like jvm_heap and cpu_request
  - Optional ability to add nodeAffinity rules for ES/Kibana and Fluentd
  - Fluentd replicaCount default from 2 to 1

## Upgrade - Without ArgoCD
### CRDs:
( commands assume latest kubezero repository being checkout next to this git repository to deploy master / non-released version )
  
  `./bootstrap.sh crds all clusters/$CLUSTER ../../../kubezero/charts`

### Components
`./bootstrap.sh deploy all clusters/$CLUSTER ../../../kubezero/charts`

## Upgrade - ArgoCD
- push latest config to git repo
- verify correct branch etc. ( argoless branch is retired ! )
- trigger sync in ArgoCD starting with the KubeZero root app  
( only if auto-sync is not enabled )

## Verification / Tests
- check if all pods are RUNNING
- check any Ingress services
- ...