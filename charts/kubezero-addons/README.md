# kubezero-addons

![Version: 0.7.0](https://img.shields.io/badge/Version-0.7.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.24](https://img.shields.io/badge/AppVersion-v1.24-informational?style=flat-square)

KubeZero umbrella chart for various optional cluster addons

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.24.0`

| Repository | Name | Version |
|------------|------|---------|
|  | aws-node-termination-handler | 0.19.3 |
| https://kubernetes-sigs.github.io/external-dns/ | external-dns | 1.11.0 |
| https://kubernetes.github.io/autoscaler | cluster-autoscaler | 9.21.0 |
| https://nvidia.github.io/k8s-device-plugin | nvidia-device-plugin | 0.12.3 |

# MetalLB   
   
# device-plugins   
   
## AWS Neuron
Device plugin for [AWS Neuron](https://aws.amazon.com/machine-learning/neuron/) - [Inf1 instances](https://aws.amazon.com/ec2/instance-types/inf1/)
   
## Nvidia

## Cluster AutoScaler
- https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws-node-termination-handler.deleteLocalData | bool | `true` |  |
| aws-node-termination-handler.emitKubernetesEvents | bool | `true` |  |
| aws-node-termination-handler.enableProbesServer | bool | `true` |  |
| aws-node-termination-handler.enablePrometheusServer | bool | `false` |  |
| aws-node-termination-handler.enableSpotInterruptionDraining | bool | `false` |  |
| aws-node-termination-handler.enableSqsTerminationDraining | bool | `true` |  |
| aws-node-termination-handler.enabled | bool | `false` |  |
| aws-node-termination-handler.extraEnv[0] | object | `{"name":"AWS_ROLE_ARN","value":""}` | "arn:aws:iam::${AWS::AccountId}:role/${AWS::Region}.${ClusterName}.awsNth" |
| aws-node-termination-handler.extraEnv[1].name | string | `"AWS_WEB_IDENTITY_TOKEN_FILE"` |  |
| aws-node-termination-handler.extraEnv[1].value | string | `"/var/run/secrets/sts.amazonaws.com/serviceaccount/token"` |  |
| aws-node-termination-handler.extraEnv[2].name | string | `"AWS_STS_REGIONAL_ENDPOINTS"` |  |
| aws-node-termination-handler.extraEnv[2].value | string | `"regional"` |  |
| aws-node-termination-handler.fullnameOverride | string | `"aws-node-termination-handler"` |  |
| aws-node-termination-handler.ignoreDaemonSets | bool | `true` |  |
| aws-node-termination-handler.jsonLogging | bool | `true` |  |
| aws-node-termination-handler.managedTag | string | `"aws-node-termination-handler/managed"` | "aws-node-termination-handler/${ClusterName}" |
| aws-node-termination-handler.metadataTries | int | `0` |  |
| aws-node-termination-handler.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| aws-node-termination-handler.podMonitor.create | bool | `false` |  |
| aws-node-termination-handler.queueURL | string | `""` | https://sqs.${AWS::Region}.amazonaws.com/${AWS::AccountId}/${ClusterName}_Nth |
| aws-node-termination-handler.rbac.pspEnabled | bool | `false` |  |
| aws-node-termination-handler.taintNode | bool | `true` |  |
| aws-node-termination-handler.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-node-termination-handler.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| aws-node-termination-handler.tolerations[1].effect | string | `"NoSchedule"` |  |
| aws-node-termination-handler.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| aws-node-termination-handler.useProviderId | bool | `true` |  |
| awsNeuron.enabled | bool | `false` |  |
| awsNeuron.image.name | string | `"public.ecr.aws/neuron/neuron-device-plugin"` |  |
| awsNeuron.image.tag | string | `"1.9.3.0"` |  |
| cluster-autoscaler.autoDiscovery.clusterName | string | `""` |  |
| cluster-autoscaler.awsRegion | string | `"us-west-2"` |  |
| cluster-autoscaler.enabled | bool | `false` |  |
| cluster-autoscaler.extraArgs.scan-interval | string | `"30s"` |  |
| cluster-autoscaler.extraArgs.skip-nodes-with-local-storage | bool | `false` |  |
| cluster-autoscaler.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| cluster-autoscaler.podDisruptionBudget | bool | `false` |  |
| cluster-autoscaler.prometheusRule.enabled | bool | `false` |  |
| cluster-autoscaler.prometheusRule.interval | string | `"30"` |  |
| cluster-autoscaler.serviceMonitor.enabled | bool | `false` |  |
| cluster-autoscaler.serviceMonitor.interval | string | `"30s"` |  |
| cluster-autoscaler.tolerations[0].effect | string | `"NoSchedule"` |  |
| cluster-autoscaler.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| cluster-autoscaler.tolerations[1].effect | string | `"NoSchedule"` |  |
| cluster-autoscaler.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| clusterBackup.enabled | bool | `false` |  |
| clusterBackup.extraEnv | list | `[]` |  |
| clusterBackup.image.name | string | `"public.ecr.aws/zero-downtime/kubezero-admin"` |  |
| clusterBackup.password | string | `""` | /etc/cloudbender/clusterBackup.passphrase |
| clusterBackup.repository | string | `""` | s3:https://s3.amazonaws.com/${CFN[ConfigBucket]}/k8s/${CLUSTERNAME}/clusterBackup |
| external-dns.enabled | bool | `false` |  |
| external-dns.env[0] | object | `{"name":"AWS_ROLE_ARN","value":""}` | "arn:aws:iam::${AWS::AccountId}:role/${AWS::Region}.${ClusterName}.externalDNS" |
| external-dns.env[1].name | string | `"AWS_WEB_IDENTITY_TOKEN_FILE"` |  |
| external-dns.env[1].value | string | `"/var/run/secrets/sts.amazonaws.com/serviceaccount/token"` |  |
| external-dns.env[2].name | string | `"AWS_STS_REGIONAL_ENDPOINTS"` |  |
| external-dns.env[2].value | string | `"regional"` |  |
| external-dns.extraVolumeMounts[0].mountPath | string | `"/var/run/secrets/sts.amazonaws.com/serviceaccount/"` |  |
| external-dns.extraVolumeMounts[0].name | string | `"aws-token"` |  |
| external-dns.extraVolumeMounts[0].readOnly | bool | `true` |  |
| external-dns.extraVolumes[0].name | string | `"aws-token"` |  |
| external-dns.extraVolumes[0].projected.sources[0].serviceAccountToken.audience | string | `"sts.amazonaws.com"` |  |
| external-dns.extraVolumes[0].projected.sources[0].serviceAccountToken.expirationSeconds | int | `86400` |  |
| external-dns.extraVolumes[0].projected.sources[0].serviceAccountToken.path | string | `"token"` |  |
| external-dns.interval | string | `"3m"` |  |
| external-dns.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| external-dns.provider | string | `"inmemory"` |  |
| external-dns.sources[0] | string | `"service"` |  |
| external-dns.tolerations[0].effect | string | `"NoSchedule"` |  |
| external-dns.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| external-dns.tolerations[1].effect | string | `"NoSchedule"` |  |
| external-dns.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| external-dns.triggerLoopOnEvent | bool | `true` |  |
| forseti.aws.iamRoleArn | string | `""` | "arn:aws:iam::${AWS::AccountId}:role/${AWS::Region}.${ClusterName}.kubezeroForseti" |
| forseti.aws.region | string | `""` |  |
| forseti.enabled | bool | `false` |  |
| forseti.image.name | string | `"public.ecr.aws/zero-downtime/forseti"` |  |
| forseti.image.tag | string | `"v0.1.2"` |  |
| fuseDevicePlugin.enabled | bool | `false` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key | string | `"node.kubernetes.io/instance-type"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator | string | `"In"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0] | string | `"g5.xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[1] | string | `"g5.2xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[2] | string | `"g5.4xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[3] | string | `"g5.8xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[4] | string | `"g5.12xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[5] | string | `"g5.16xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[6] | string | `"g5.24xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[7] | string | `"g5.48xlarge"` |  |
| nvidia-device-plugin.enabled | bool | `false` |  |
| nvidia-device-plugin.tolerations[0].effect | string | `"NoSchedule"` |  |
| nvidia-device-plugin.tolerations[0].key | string | `"nvidia.com/gpu"` |  |
| nvidia-device-plugin.tolerations[0].operator | string | `"Exists"` |  |
| nvidia-device-plugin.tolerations[1].effect | string | `"NoSchedule"` |  |
| nvidia-device-plugin.tolerations[1].key | string | `"kubezero-workergroup"` |  |
| nvidia-device-plugin.tolerations[1].operator | string | `"Exists"` |  |
