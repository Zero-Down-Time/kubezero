# kubezero-aws-efs-csi-driver

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

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

Kubernetes: `>=1.16.0-0`

| Repository | Name | Version |
|------------|------|---------|
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
| aws-efs-csi-driver.nodeSelector | object | `{}` |  |
