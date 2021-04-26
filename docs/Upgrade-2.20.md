# Upgrade to KubeZero V2.20 / Kubernetes 1.20

# CloudBender
## Changes
- controller node names are now strictly tight to the AZ they are in: AZ1 -> controller00, AZ2 -> controller01 etc. to prevent controller03 from happening in case AWS launches new instances before the old ones are actually terminated 
 
## Upgrade
- Set Kubernetes version in the controller config to eg. `1.20`  
- Update controller and worker stacks with latest CFN code

- Upgrade requires careful replacement in case existing control planes are shuffled otherwise: ( this might reduce the number of online controllers temporarily to 1 ! )
  - manually set controller ASG to Min/Maz 0 for the ASG currently hosting controller00
  - terminate controller node in AZ1 which will return as controller00
  - replace controller01 and 02 in similar fashion

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
- Grafana Dashboards are now all provided via configmaps, no more storing of state required
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
