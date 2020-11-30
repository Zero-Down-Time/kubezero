# Upgrade to KubeZero V2(Argoless)

- disable all auto-sync in argo !! ( remove auto-sync from old values.yaml and run deploy one last time ) or disable manual via Argo UI starting with Kubezero app itself

- uninstall argo helm chart
  `helm uninstall kubezero -n argocd`

- migrate values.yaml to new structure, adapt as needed
- update new central kubezero location in git and merge cluster configs

- Upgrade control plane nodes / worker nodes

- upgrade all crds
- upgrade calico,cert-manager,kiam,csi drivers
- Istio: 

## High level / Admin changes
- ArgoCD is now optional
- ArgoCD is NOT required nor used during initial cluster bootstrap
- the initial bootstrap script now uses the same config as ArgoCD later on
- the initial bootstrap is WAY faster and re-try safe

## Individual changes

### Cert-manager
- local issuer is now a cluster issuer
- all resources moved to cert-manager namespace

### Kiam
- check certs and function due to cert-manager changes
- set priorty class

### Logging
- ES/Kibana version bump, new ECK operator

### ArgoCD
- version bump, new app of app architecure

### Metrics
- version bumps
- all servicemonitor resources are now in the same namespaces as the apps
- check all metrics still work

### Calico
- version bump

### EBS
- version bump

### Istio
- operator removed, deployment migrated to helm, cleanups
- version bump to 1.8
- no more policy by default
- all ingress in dedicated new namespace istio-ingress as well as dedicated helm chart
- set priorty class
