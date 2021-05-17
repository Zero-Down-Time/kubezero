# kubezero-aws-ebs-csi-driver

![Version: 0.5.1](https://img.shields.io/badge/Version-0.5.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.10.0](https://img.shields.io/badge/AppVersion-0.10.0-informational?style=flat-square)

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

Kubernetes: `>= 1.18.0`

| Repository | Name | Version |
|------------|------|---------|
| https://kubernetes-sigs.github.io/aws-ebs-csi-driver | aws-ebs-csi-driver | 0.10.0 |
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
| aws-ebs-csi-driver.enableVolumeResizing | bool | `true` |  |
| aws-ebs-csi-driver.enableVolumeScheduling | bool | `true` |  |
| aws-ebs-csi-driver.enableVolumeSnapshot | bool | `true` |  |
| aws-ebs-csi-driver.extraVolumeTags | object | `{}` | Optional tags to be added to each EBS volume |
| aws-ebs-csi-driver.logLevel | int | `1` |  |
| aws-ebs-csi-driver.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| aws-ebs-csi-driver.podAnnotations | object | `{}` | iam.amazonaws.com/role: <IAM role ARN> to assume |
| aws-ebs-csi-driver.replicaCount | int | `1` |  |
| aws-ebs-csi-driver.resources.limits.memory | string | `"40Mi"` |  |
| aws-ebs-csi-driver.resources.requests.cpu | string | `"10m"` |  |
| aws-ebs-csi-driver.resources.requests.memory | string | `"24Mi"` |  |
| aws-ebs-csi-driver.storageClasses[0].allowVolumeExpansion | bool | `true` |  |
| aws-ebs-csi-driver.storageClasses[0].name | string | `"ebs-sc-gp2-xfs"` |  |
| aws-ebs-csi-driver.storageClasses[0].parameters."csi.storage.k8s.io/fstype" | string | `"xfs"` |  |
| aws-ebs-csi-driver.storageClasses[0].parameters.encrypted | string | `"true"` |  |
| aws-ebs-csi-driver.storageClasses[0].parameters.type | string | `"gp2"` |  |
| aws-ebs-csi-driver.storageClasses[0].volumeBindingMode | string | `"WaitForFirstConsumer"` |  |
| aws-ebs-csi-driver.storageClasses[1].allowVolumeExpansion | bool | `true` |  |
| aws-ebs-csi-driver.storageClasses[1].annotations."storageclass.kubernetes.io/is-default-class" | string | `"true"` |  |
| aws-ebs-csi-driver.storageClasses[1].name | string | `"ebs-sc-gp3-xfs"` |  |
| aws-ebs-csi-driver.storageClasses[1].parameters."csi.storage.k8s.io/fstype" | string | `"xfs"` |  |
| aws-ebs-csi-driver.storageClasses[1].parameters.encrypted | string | `"true"` |  |
| aws-ebs-csi-driver.storageClasses[1].parameters.type | string | `"gp3"` |  |
| aws-ebs-csi-driver.storageClasses[1].volumeBindingMode | string | `"WaitForFirstConsumer"` |  |
| aws-ebs-csi-driver.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
