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
1. Update CRDs of all enabled components:  
  `./bootstrap.sh crds all clusters/$CLUSTER`

2. Prepare upgrade
- delete old fluentd deployement because labels are immutable and they changed due to the migration to new upstream helm chart  
`kubectl delete deployment logging-fluentd -n logging`

3. Upgrade all components  
`./bootstrap.sh deploy all clusters/$CLUSTER`

## Upgrade - ArgoCD
- ArgoCD needs to be upgraded first to support latest Helm chart requirements: `./bootstrap.sh deploy argocd clusters/$CLUSTER`
- push latest cluster config to your git repo
- verify correct branch etc. ( eg. argoless branch has been retired ! )
- trigger sync in ArgoCD starting with the KubeZero root app  
( only if auto-sync is not enabled )

## Verification / Tests
- check if all pods are RUNNING
- check any Ingress services
- ...
