kubezero
========
KubeZero ArgoCD Application - Root App of Apps chart of KubeZero

Current chart version is `0.4.5`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws-ebs-csi-driver.enabled | bool | `false` |  |
| aws-efs-csi-driver.enabled | bool | `false` |  |
| calico.enabled | bool | `false` |  |
| calico.retain | bool | `true` |  |
| cert-manager.enabled | bool | `false` |  |
| cert-manager.namespace | string | `"cert-manager"` |  |
| global.defaultDestination.server | string | `"https://kubernetes.default.svc"` |  |
| global.defaultSource.pathPrefix | string | `""` |  |
| global.defaultSource.repoURL | string | `"https://github.com/zero-down-time/kubezero"` |  |
| global.defaultSource.targetRevision | string | `"HEAD"` |  |
| istio.enabled | bool | `false` |  |
| kiam.enabled | bool | `false` |  |
| local-volume-provisioner.enabled | bool | `false` |  |
| logging.enabled | bool | `false` |  |
| logging.namespace | string | `"logging"` |  |
| metrics.enabled | bool | `false` |  |
| metrics.namespace | string | `"monitoring"` |  |
| platform | string | `"aws"` |  |
