# Calico CNI

## Known issues
Due to a bug in Kustomize V2 vs. V3 we have to remove all namespaces from the base resources.
The kube-system namespace will be applied by kustomize.  

See eg: `https://github.com/kubernetes-sigs/kustomize/issues/1351`

## Upgrade
See: https://docs.projectcalico.org/maintenance/kubernetes-upgrade  
`curl https://docs.projectcalico.org/manifests/canal.yaml -O && patch < remove-namespace.patch`
