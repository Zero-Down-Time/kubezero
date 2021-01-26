# Changelog

## KubeZero - 2.18 ( Argoless )

### High level / Admin changes
- ArgoCD is now optional and NOT required nor used during initial cluster bootstrap
- the bootstrap process now uses the same config and templates as the optional ArgoCD applications later on
- the bootstrap is can now be restarted at any time and considerably faster
- the top level KubeZero config for the ArgoCD app-of-apps is now also maintained via the gitops workflow. Changes can be applied by a simple git push rather than manual scripts

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
- ES/Kibana version bump to 7.10  
- ECK operator is now installed on demand in logging ns
- Custom event fields configurable via new fluent-bit chart    
  e.g. clustername could be added to each event allowing easy filtering in case multiple clusters stream events into a single central ES cluster

### ArgoCD
- version bump, new app of app architecure

### Metrics
- version bump
- all servicemonitor resources are now in the same namespaces as the respective apps to avoid deployments across multiple namespaces

### upstream Kubernetes 1.18
https://sysdig.com/blog/whats-new-kubernetes-1-18/
