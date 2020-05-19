kubezero-aws-ebs
================
KubeZero Umbrella Chart for aws-ebs-csi-driver

Current chart version is `0.1.0`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.1 |

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws-ebs-csi-driver.enableVolumeResizing | bool | `false` |  |
| aws-ebs-csi-driver.enableVolumeScheduling | bool | `true` |  |
| aws-ebs-csi-driver.enableVolumeSnapshot | bool | `false` |  |
| aws-ebs-csi-driver.extraVolumeTags | object | `{}` | Optional tags to be added to each EBS volume |
| aws-ebs-csi-driver.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| aws-ebs-csi-driver.podAnnotations | object | `{}` |  iam.amazonaws.com/role: <IAM role ARN> to assume |
| aws-ebs-csi-driver.replicaCount | int | `1` |  |
| aws-ebs-csi-driver.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-ebs-csi-driver.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
