# Upgrade to KubeZero V2(Argoless)

## ArgoCD prep
- disable all auto-sync and "prune" feature to prevent that namespaces defined in previous apps get removed
  - either remove auto-sync from old values.yaml and run deploy one last time, trigger kubezero sync !
  - or disable manual via Argo UI starting with Kubezero app itself

- uninstall argo helm chart
  `helm uninstall kubezero -n argocd`
- remove all "argocd.argoproj.io/instance" labels from namespaces to prevent namespace removal later on
  `scripts/remove_argo_ns.sh`

- migrate values.yaml to new structure, adapt as needed
  & update new central kubezero location in git and merge cluster configs

- Upgrade control plane nodes / worker nodes

- upgrade all crds
  `./bootstrap.sh crds all clusters/$CLUSTER ../../../kubezero/charts`

- upgrade base artifacts
  `./bootstrap.sh deploy calico,cert-manager,kiam,aws-ebs-csi-driver,aws-efs-csi-driver clusters/$CLUSTER ../../../kubezero/charts`

- Istio, due to changes of the ingress namespace we need brief downtime
DOWNTIME STARTS !
  - delete istio operators, to remove all pieces, remove operator itself
   `./scripts/delete_istio_17.sh`
  - deploy istio and istio-ingress via bootstrap.sh
  `./bootstrap.sh deploy all clusters/$CLUSTER ../../../kubezero/charts`
  - patch all VirtualServices via script to new namespace
  `./scripts/patch_vs.sh`
DOWNTIME ENDS !

- upgrade all artifacts
  `./bootstrap.sh deploy all clusters/$CLUSTER ../../../kubezero/charts`

- push kubezero cluster config
- verify argocd incl. kubezero app
- verify all argo apps
- verify all the things


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
- no more policy pod by default
- all ingress in dedicated new namespace istio-ingress as well as dedicated helm chart
- set priorty class
