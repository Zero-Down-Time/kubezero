kubezero-app
============
KubeZero ArgoCD Application - Root chart of the KubeZero

Current chart version is `0.1.3`

Source code can be found [here](https://kubezero.com)



## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| calico.enabled | bool | `false` |  |
| certManager.enabled | bool | `false` |  |
| defaultDestination.server | string | `"https://kubernetes.default.svc"` |  |
| defaultSource.pathPrefix | string | `""` | optional path prefix within repoURL to support eg. remote subtrees |
| defaultSource.repoURL | string | `"https://github.com/zero-down-time/kubezero"` | default repository for argocd applications |
| defaultSource.targetRevision | string | `"HEAD"` | default tracking of repoURL |
| localVolumeProvisioner.enabled | bool | `false` |  |
