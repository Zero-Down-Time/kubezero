# kubezero-aws-efs-csi-driver

![Version: 0.3.5](https://img.shields.io/badge/Version-0.3.5-informational?style=flat-square) ![AppVersion: 1.2.0](https://img.shields.io/badge/AppVersion-1.2.0-informational?style=flat-square)

KubeZero Umbrella Chart for aws-efs-csi-driver

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Source Code

* <https://github.com/Zero-Down-Time/kubezero>
* <https://github.com/kubernetes-sigs/aws-efs-csi-driver>

## Requirements

Kubernetes: `>=1.18.0-0`

| Repository | Name | Version |
|------------|------|---------|
|  | aws-efs-csi-driver | 1.2.2 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Storage Class
Optionally creates the *efs-cs* storage class.
Could also be made the default storage class if requested.

## Multiple PVs & PVCs backed by same EFS file system
Details also see: [Reserve PV](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#reserving-a-persistentvolume)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| StorageClass.create | bool | `true` |  |
| StorageClass.default | bool | `false` |  |
| aws-efs-csi-driver.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key | string | `"node.kubernetes.io/csi.efs.fs"` |  |
| aws-efs-csi-driver.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator | string | `"Exists"` |  |
| aws-efs-csi-driver.logLevel | int | `1` |  |
| aws-efs-csi-driver.resources.limits.memory | string | `"128Mi"` |  |
| aws-efs-csi-driver.resources.requests.cpu | string | `"20m"` |  |
| aws-efs-csi-driver.resources.requests.memory | string | `"64Mi"` |  |
