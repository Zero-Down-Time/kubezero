# kubezero-aws-ebs-csi-driver

![Version: 0.3.1](https://img.shields.io/badge/Version-0.3.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.6.0](https://img.shields.io/badge/AppVersion-0.6.0-informational?style=flat-square)

KubeZero Umbrella Chart for aws-ebs-csi-driver

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Source Code

* <https://github.com/kubernetes-sigs/aws-ebs-csi-driver>
* <https://github.com/Zero-Down-Time/kubezero>

## Requirements

Kubernetes: `>= 1.16.0`

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## IAM Role
If you use kiam or kube2iam and restrict access on nodes running this controller please adjust:
```
podAnnotations:
  iam.amazonaws.com/role: <ROLE>
```

## Storage Classes
By default it also creates the *ebs-sc-gp2-xfs* storage class for gp2, enrypted and XFS.
This class is by default also set as default storage class.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| StorageClass.create | bool | `true` |  |
| StorageClass.default | bool | `true` |  |
| aws-ebs-csi-driver.enableVolumeResizing | bool | `false` |  |
| aws-ebs-csi-driver.enableVolumeScheduling | bool | `true` |  |
| aws-ebs-csi-driver.enableVolumeSnapshot | bool | `false` |  |
| aws-ebs-csi-driver.extraVolumeTags | object | `{}` | Optional tags to be added to each EBS volume |
| aws-ebs-csi-driver.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| aws-ebs-csi-driver.podAnnotations | object | `{}` | iam.amazonaws.com/role: <IAM role ARN> to assume |
| aws-ebs-csi-driver.replicaCount | int | `1` |  |
| aws-ebs-csi-driver.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
