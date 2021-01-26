# Upgrade to KubeZero V2.18.0 (Argoless)

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

- if logging incl. ElasticSearch is installed remove the old ECK operator first:  
  `./scripts/remove_old_eck.sh`

- upgrade all remaining components and install new ArgoCD:  
  `./bootstrap.sh deploy all clusters/$CLUSTER ../../../kubezero/charts`

## Verification / Tests
- verify argocd incl. kubezero app
- verify all argo apps status
- verify all the things
