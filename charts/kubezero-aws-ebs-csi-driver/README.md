kubezero-aws-ebs-csi-driver
===========================
KubeZero Umbrella Chart for aws-ebs-csi-driver

Current chart version is `0.2.0`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.1 |

## IAM Role
If you use kiam or kube2iam and restrict access on nodes running this controller please adjust:
```
podAnnotations:
  iam.amazonaws.com/role: <ROLE>
```

## Storage Classes
By default it also creates the *ebs-sc-gp2-xfs* storage class for gp2, enrypted and XFS.
This class is by default also set as default storage class.

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| StorageClass.create | bool | `true` |  |
| StorageClass.default | bool | `true` |  |
| aws-ebs-csi-driver.enableVolumeResizing | bool | `false` |  |
| aws-ebs-csi-driver.enableVolumeScheduling | bool | `true` |  |
| aws-ebs-csi-driver.enableVolumeSnapshot | bool | `false` |  |
| aws-ebs-csi-driver.extraVolumeTags | object | `{}` | Optional tags to be added to each EBS volume |
| aws-ebs-csi-driver.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| aws-ebs-csi-driver.podAnnotations | object | `{}` |  iam.amazonaws.com/role: <IAM role ARN> to assume |
| aws-ebs-csi-driver.replicaCount | int | `1` |  |
| aws-ebs-csi-driver.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
