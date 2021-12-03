# kubezero-storage

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things storage incl. backup, eg. openEBS-lvm, gemini

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.18.0`

| Repository | Name | Version |
|------------|------|---------|
|  | aws-ebs-csi-driver | 2.3.0 |
|  | aws-efs-csi-driver | 2.1.5 |
|  | gemini | 0.0.7 |
|  | lvm-localpv | 0.8.5 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws-ebs-csi-driver.controller.logLevel | int | `2` |  |
| aws-ebs-csi-driver.controller.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| aws-ebs-csi-driver.controller.replicaCount | int | `1` |  |
| aws-ebs-csi-driver.controller.resources.limits.memory | string | `"40Mi"` |  |
| aws-ebs-csi-driver.controller.resources.requests.cpu | string | `"10m"` |  |
| aws-ebs-csi-driver.controller.resources.requests.memory | string | `"24Mi"` |  |
| aws-ebs-csi-driver.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| aws-ebs-csi-driver.enabled | bool | `false` |  |
| aws-ebs-csi-driver.node.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.node.tolerations[0].key | string | `"kubezero-workergroup"` |  |
| aws-ebs-csi-driver.node.tolerations[0].operator | string | `"Exists"` |  |
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
| aws-efs-csi-driver.controller.create | bool | `true` |  |
| aws-efs-csi-driver.controller.logLevel | int | `2` |  |
| aws-efs-csi-driver.controller.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| aws-efs-csi-driver.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-efs-csi-driver.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| aws-efs-csi-driver.enabled | bool | `false` |  |
| aws-efs-csi-driver.node.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key | string | `"node.kubernetes.io/csi.efs.fs"` |  |
| aws-efs-csi-driver.node.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator | string | `"Exists"` |  |
| aws-efs-csi-driver.node.logLevel | int | `2` |  |
| aws-efs-csi-driver.node.resources.limits.memory | string | `"128Mi"` |  |
| aws-efs-csi-driver.node.resources.requests.cpu | string | `"20m"` |  |
| aws-efs-csi-driver.node.resources.requests.memory | string | `"64Mi"` |  |
| aws-efs-csi-driver.node.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-efs-csi-driver.node.tolerations[0].key | string | `"kubezero-workergroup"` |  |
| aws-efs-csi-driver.node.tolerations[0].operator | string | `"Exists"` |  |
| aws-efs-csi-driver.replicaCount | int | `1` |  |
| aws-efs-csi-driver.storageClasses[0].name | string | `"efs-sc"` |  |
| gemini.enabled | bool | `false` |  |
| gemini.resources.limits.cpu | string | `"400m"` |  |
| gemini.resources.limits.memory | string | `"128Mi"` |  |
| gemini.resources.requests.cpu | string | `"20m"` |  |
| gemini.resources.requests.memory | string | `"32Mi"` |  |
| lvm-localpv.analytics.enabled | bool | `false` |  |
| lvm-localpv.enabled | bool | `false` |  |
| lvm-localpv.lvmController.logLevel | int | `2` |  |
| lvm-localpv.lvmController.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| lvm-localpv.lvmController.tolerations[0].effect | string | `"NoSchedule"` |  |
| lvm-localpv.lvmController.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| lvm-localpv.lvmNode.logLevel | int | `2` |  |
| lvm-localpv.lvmNode.nodeSelector."node.kubernetes.io/lvm" | string | `"openebs"` |  |
| lvm-localpv.lvmNode.tolerations[0].effect | string | `"NoSchedule"` |  |
| lvm-localpv.lvmNode.tolerations[0].key | string | `"kubezero-workergroup"` |  |
| lvm-localpv.lvmNode.tolerations[0].operator | string | `"Exists"` |  |
| lvm-localpv.storageCapacity | bool | `false` |  |
| lvm-localpv.storageClass.default | bool | `false` |  |
| lvm-localpv.storageClass.vgpattern | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
