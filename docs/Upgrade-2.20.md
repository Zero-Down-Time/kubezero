# Upgrade to KubeZero V2.20 / Kubernetes 1.20

# CloudBender
## Changes
### Single node control plane
- Control
 
## Upgrade
- Set the specific wanted Kubernetes version in the controller config to eg. `v1.20.2`  
- configure your AWS CLI profile as well as your kubectl context to cluster you want to upgrade.
- verify your config ...

- run ./scripts/upgrade_120.sh
- update the CFN stack for kube-control-plane

### Single node control plane
- will automatically be upgraded and the controller node replaced as part of the CFN update

### Clustered control plane
- replace controller instances one by one in no particular order
- once confirmed that the upgraded 1.20 control plane is working as expected update the clustered control plane CFN stack once more with `LBType: none` to remove the AWS NLB fronting the Kubernetes API which is not required anymore.

- replace worker nodes in a rolling fashion via. drain / terminate / rinse-repeat

# KubeZero

## New features

### NATS
Deploy NATS services

### TimeCapsule
Providing backup solutions for KubeZero clusters:
  
- scheduled snapshots for EBS backed PVCs incl. custome retention and restore


## Changes

### General
- various version bumps
- removed deprecated nodeLabels from `failure-domain.beta.kubernetes.io/[region|zone]` to `topology.kubernetes.io/[region|zone]` please adapt existing affinity rules !

### Istio
- hardened and optimized settings for Envoy gateway proxies
- improved deployment strategy to reduce errors during upgrades
- Added various Grafana Dashboards

## Metrics
- Added various dashboards for KubeZero modules
- Updated / improved dashboard organization incl. folders and tags
- Grafana Dashboards are now all provided via configmaps, no more state required, no manual changes persisted
- Grafana allows anonymous read-only access
- all dashboards ndefault to now-1h and prohibit less than 30s refresh
- Custom dashboards can easily be provided by simple installing a ConfigMap along with workloads in any namespace


## Upgrade - Without ArgoCD
1. Update CRDs of all enabled components:  
  `./bootstrap.sh crds all clusters/$CLUSTER`

2. Prepare upgrade
- Remove legacy monitoring configmaps
- Remove previous Grafana stateful config
- Remove legacy Istio Enovyfilter

```
kubectl delete cm -n monitoring -l grafana_dashboard=1
kubectl delete pvc metrics-grafana -n monitoring
kubectl delete envoyfilter -A -l operator.istio.io/version=1.6.9
```

3. Upgrade all components  
`./bootstrap.sh deploy all clusters/$CLUSTER`

## Upgrade - ArgoCD
- ArgoCD itself: `./bootstrap.sh deploy argocd clusters/$CLUSTER`
- push latest cluster config to your git repo
- trigger sync in ArgoCD incl. *prune* starting with the KubeZero root app  
( only if auto-sync is not enabled )

## Verification / Tests
- check if all pods are RUNNING
- check any Ingress services
- ...
