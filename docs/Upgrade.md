# Upgrade to KubeZero V2(Argoless)

## (optional) Upgrade control plane nodes / worker nodes
- Set kube version in the controller config to eg. `1.18`  
- Update kube-controller and worker stacks with latest CFN code

- terminate controller node(s)
- once all controller nodes successfully upgraded replace worker nodes in a rolling fashion via. drain / terminate / rinse-repeat

## ArgoCD
- disable all auto-sync and "prune" features to prevent that eg. namespaces from previous apps get removed
  - either remove auto-sync from old values.yaml and run deploy one last time, trigger kubezero sync !
  - or disable manual via Argo UI starting with Kubezero app itself

- uninstall argo helm chart:  
`helm uninstall kubezero -n argocd`

- remove all "argocd.argoproj.io/instance" labels from namespaces to prevent namespace removal later on:  
  `./scripts/remove_argo_ns.sh`

## KubeZero - Part 1
- migrate values.yaml to new structure, adapt as needed
  & update new central kubezero location in git and merge cluster configs

- upgrade all CRDs:  
  `./bootstrap.sh crds all clusters/$CLUSTER ../../../kubezero/charts`

- upgrade first components:  
  `./bootstrap.sh deploy calico,cert-manager,kiam,aws-ebs-csi-driver,aws-efs-csi-driver clusters/$CLUSTER ../../../kubezero/charts`

## Istio
Due to changes of the ingress namespace resource the upgrade will cause a brief (~3-5 min) ingress service interruption !  

  - delete istio operators, to remove all pieces, remove operator itself
   `./scripts/delete_istio_17.sh`
  - deploy istio and istio-ingress via bootstrap.sh
  `./bootstrap.sh deploy istio,istio-ingress clusters/$CLUSTER ../../../kubezero/charts`
  - patch all VirtualServices via script to new namespace
  `./scripts/patch_vs.sh`

Ingress service interruption ends.

## KubeZero - Part 2

- push kubezero & cluster config to git

- upgrade all remaining components and install new ArgoCD:  
  `./bootstrap.sh deploy all clusters/$CLUSTER ../../../kubezero/charts`

## Verification / Tests
- verify argocd incl. kubezero app
- verify all argo apps status

- verify all the things



# Changelog

## Kubernetes 1.18
https://sysdig.com/blog/whats-new-kubernetes-1-18/

## High level / Admin changes
- ArgoCD is now optional and NOT required nor used during initial cluster bootstrap
- the bootstrap process now uses the same config and templates as the optional ArgoCD applications later on
- the bootstrap is can now be restarted at any time and considerably faster
- the top level KubeZero config for the ArgoCD app-of-apps is now also maintained via the gitops workflow. Changes can be applied by a simple git push rather than manual scripts

## Individual changes

### Calico
- version bump

### Cert-manager
- local issuers are now cluster issuer to allow them being used across namespaces
- all cert-manager resources moved into the cert-manager namespace
- version bump to 1.10

### Kiam
- set priorty class to cluster essential
- certificates are now issued by the cluster issuer

### EBS / EFS
- version bump

### Istio
- istio operator removed, deployment migrated to helm, various cleanups
- version bump to 1.8
- all ingress resources are now in the dedicated new namespace istio-ingress ( deployed via separate kubezero chart istio-ingress)
- set priorty class of ingress components to cluster essential

### Logging
- ES/Kibana version bump, new ECK operator

### ArgoCD
- version bump, new app of app architecure

### Metrics
- version bump
- all servicemonitor resources are now in the same namespaces as the respective apps to avoid namespace spanning deployments


