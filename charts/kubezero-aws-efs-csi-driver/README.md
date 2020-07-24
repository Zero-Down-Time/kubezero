kubezero-aws-efs-csi-driver
===========================
KubeZero Umbrella Chart for aws-efs-csi-driver

Current chart version is `0.1.0`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.1 |

## Storage Class
Optionally creates the *efs-cs* storage class.
Could also be made the default storage class if requested.

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| PersistentVolume.EfsId | string | `""` |  |
| PersistentVolume.Name | string | `""` |  |
| PersistentVolume.create | bool | `false` |  |
| StorageClass.create | bool | `true` |  |
| StorageClass.default | bool | `false` |  |
| aws-efs-csi-driver.nodeSelector | object | `{}` |  |
