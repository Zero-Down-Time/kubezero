# kubezero-storage

![Version: 0.7.4](https://img.shields.io/badge/Version-0.7.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things storage incl. AWS EBS/EFS, openEBS-lvm, gemini

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.24.0`

| Repository | Name | Version |
|------------|------|---------|
|  | aws-efs-csi-driver | 2.3.2 |
|  | gemini | 1.0.0 |
|  | lvm-localpv | 1.0.0 |
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.6 |
| https://kubernetes-sigs.github.io/aws-ebs-csi-driver | aws-ebs-csi-driver | 2.13.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws-ebs-csi-driver.controller.defaultFsType | string | `"xfs"` |  |
| aws-ebs-csi-driver.controller.logLevel | int | `2` |  |
| aws-ebs-csi-driver.controller.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| aws-ebs-csi-driver.controller.replicaCount | int | `1` |  |
| aws-ebs-csi-driver.controller.resources.limits.memory | string | `"40Mi"` |  |
| aws-ebs-csi-driver.controller.resources.requests.cpu | string | `"10m"` |  |
| aws-ebs-csi-driver.controller.resources.requests.memory | string | `"24Mi"` |  |
| aws-ebs-csi-driver.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| aws-ebs-csi-driver.controller.tolerations[1].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.controller.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| aws-ebs-csi-driver.controller.volumeMounts[0].mountPath | string | `"/var/run/secrets/sts.amazonaws.com/serviceaccount/"` |  |
| aws-ebs-csi-driver.controller.volumeMounts[0].name | string | `"aws-token"` |  |
| aws-ebs-csi-driver.controller.volumeMounts[0].readOnly | bool | `true` |  |
| aws-ebs-csi-driver.controller.volumes[0].name | string | `"aws-token"` |  |
| aws-ebs-csi-driver.controller.volumes[0].projected.sources[0].serviceAccountToken.audience | string | `"sts.amazonaws.com"` |  |
| aws-ebs-csi-driver.controller.volumes[0].projected.sources[0].serviceAccountToken.expirationSeconds | int | `86400` |  |
| aws-ebs-csi-driver.controller.volumes[0].projected.sources[0].serviceAccountToken.path | string | `"token"` |  |
| aws-ebs-csi-driver.enabled | bool | `false` |  |
| aws-ebs-csi-driver.node.resources.limits.memory | string | `"32Mi"` |  |
| aws-ebs-csi-driver.node.resources.requests.cpu | string | `"10m"` |  |
| aws-ebs-csi-driver.node.resources.requests.memory | string | `"16Mi"` |  |
| aws-ebs-csi-driver.node.tolerateAllTaints | bool | `false` |  |
| aws-ebs-csi-driver.node.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.node.tolerations[0].key | string | `"kubezero-workergroup"` |  |
| aws-ebs-csi-driver.node.tolerations[0].operator | string | `"Exists"` |  |
| aws-ebs-csi-driver.node.tolerations[1].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.node.tolerations[1].key | string | `"nvidia.com/gpu"` |  |
| aws-ebs-csi-driver.node.tolerations[1].operator | string | `"Exists"` |  |
| aws-ebs-csi-driver.node.tolerations[2].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.node.tolerations[2].key | string | `"aws.amazon.com/neuron"` |  |
| aws-ebs-csi-driver.node.tolerations[2].operator | string | `"Exists"` |  |
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
| aws-efs-csi-driver.controller.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| aws-efs-csi-driver.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-efs-csi-driver.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| aws-efs-csi-driver.controller.tolerations[1].effect | string | `"NoSchedule"` |  |
| aws-efs-csi-driver.controller.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
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
| aws-efs-csi-driver.node.tolerations[1].effect | string | `"NoSchedule"` |  |
| aws-efs-csi-driver.node.tolerations[1].key | string | `"nvidia.com/gpu"` |  |
| aws-efs-csi-driver.node.tolerations[1].operator | string | `"Exists"` |  |
| aws-efs-csi-driver.node.tolerations[2].effect | string | `"NoSchedule"` |  |
| aws-efs-csi-driver.node.tolerations[2].key | string | `"aws.amazon.com/neuron"` |  |
| aws-efs-csi-driver.node.tolerations[2].operator | string | `"Exists"` |  |
| aws-efs-csi-driver.replicaCount | int | `1` |  |
| gemini.enabled | bool | `false` |  |
| gemini.resources.limits.cpu | string | `"400m"` |  |
| gemini.resources.limits.memory | string | `"128Mi"` |  |
| gemini.resources.requests.cpu | string | `"20m"` |  |
| gemini.resources.requests.memory | string | `"32Mi"` |  |
| lvm-localpv.analytics.enabled | bool | `false` |  |
| lvm-localpv.enabled | bool | `false` |  |
| lvm-localpv.lvmController.logLevel | int | `2` |  |
| lvm-localpv.lvmController.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| lvm-localpv.lvmController.tolerations[0].effect | string | `"NoSchedule"` |  |
| lvm-localpv.lvmController.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| lvm-localpv.lvmController.tolerations[1].effect | string | `"NoSchedule"` |  |
| lvm-localpv.lvmController.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| lvm-localpv.lvmNode.logLevel | int | `2` |  |
| lvm-localpv.lvmNode.nodeSelector."node.kubernetes.io/lvm" | string | `"openebs"` |  |
| lvm-localpv.lvmNode.tolerations[0].effect | string | `"NoSchedule"` |  |
| lvm-localpv.lvmNode.tolerations[0].key | string | `"kubezero-workergroup"` |  |
| lvm-localpv.lvmNode.tolerations[0].operator | string | `"Exists"` |  |
| lvm-localpv.prometheus.enabled | bool | `false` |  |
| lvm-localpv.storageClass.default | bool | `false` |  |
| lvm-localpv.storageClass.vgpattern | string | `""` |  |
| snapshotController.enabled | bool | `false` |  |
| snapshotController.logLevel | int | `2` |  |
| snapshotController.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| snapshotController.replicas | int | `1` |  |
| snapshotController.resources.limits.cpu | string | `"100m"` |  |
| snapshotController.resources.limits.memory | string | `"64Mi"` |  |
| snapshotController.resources.requests.cpu | string | `"20m"` |  |
| snapshotController.resources.requests.memory | string | `"16Mi"` |  |
| snapshotController.tolerations[0].effect | string | `"NoSchedule"` |  |
| snapshotController.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| snapshotController.tolerations[1].effect | string | `"NoSchedule"` |  |
| snapshotController.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |

# Snapshotter
- https://kubernetes-csi.github.io/docs/snapshot-controller.html#deployment

## Resources
- https://github.com/openebs/monitoring/blob/develop/docs/openebs-mixin-user-guide.md#install-openebs-mixin-in-existing-prometheus-stack
- https://quay.io/organization/fairwinds
