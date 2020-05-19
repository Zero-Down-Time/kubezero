kubezero-app
============
KubeZero ArgoCD Application - Root chart of the KubeZero

Current chart version is `0.2.1`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.1 |

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| calico.enabled | bool | `false` |  |
| cert-manager.enabled | bool | `false` |  |
| global.defaultDestination.server | string | `"https://kubernetes.default.svc"` |  |
| global.defaultSource.pathPrefix | string | `""` |  |
| global.defaultSource.repoURL | string | `"https://github.com/zero-down-time/kubezero"` |  |
| global.defaultSource.targetRevision | string | `"HEAD"` |  |
| kiam.enabled | bool | `false` |  |
| local-volume-provisioner.enabled | bool | `false` |  |
