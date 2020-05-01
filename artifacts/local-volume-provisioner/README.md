# local-volume-provisioner
Provides persistent volumes backed by local volumes, eg. additional SSDs or spindles.  

As the upstream Helm chart is not part of a repository we extract the chart and store it locally as base for kustomize.  
See `update.sh`.

## Kustomizations
- add nodeSelector to only install on nodes actually having ephemeral local storage
- provide matching storage class to expose mounted disks under `/mnt/disks`

## Resources
- https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner.git
