# kubezero-addons

![Version: 0.8.1](https://img.shields.io/badge/Version-0.8.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.26](https://img.shields.io/badge/AppVersion-v1.26-informational?style=flat-square)

KubeZero umbrella chart for various optional cluster addons

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.26.0`

| Repository | Name | Version |
|------------|------|---------|
| https://bitnami-labs.github.io/sealed-secrets | sealed-secrets | 2.12.0 |
| https://falcosecurity.github.io/charts | falco-control-plane(falco) | 3.5.0 |
| https://kubernetes-sigs.github.io/external-dns/ | external-dns | 1.13.0 |
| https://kubernetes.github.io/autoscaler | cluster-autoscaler | 9.29.1 |
| https://nvidia.github.io/k8s-device-plugin | nvidia-device-plugin | 0.14.1 |
| https://twin.github.io/helm-charts | aws-eks-asg-rolling-update-handler | 1.4.0 |
| oci://public.ecr.aws/aws-ec2/helm | aws-node-termination-handler | 0.22.0 |

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
| aws-eks-asg-rolling-update-handler.enabled | bool | `false` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[0].name | string | `"CLUSTER_NAME"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[0].value | string | `""` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[1].name | string | `"AWS_REGION"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[1].value | string | `"us-west-2"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[2].name | string | `"EXECUTION_INTERVAL"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[2].value | string | `"60"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[3].name | string | `"METRICS"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[3].value | string | `"true"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[4].name | string | `"EAGER_CORDONING"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[4].value | string | `"true"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[5].name | string | `"SLOW_MODE"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[5].value | string | `"true"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[6].name | string | `"AWS_ROLE_ARN"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[6].value | string | `""` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[7].name | string | `"AWS_WEB_IDENTITY_TOKEN_FILE"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[7].value | string | `"/var/run/secrets/sts.amazonaws.com/serviceaccount/token"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[8].name | string | `"AWS_STS_REGIONAL_ENDPOINTS"` |  |
| aws-eks-asg-rolling-update-handler.environmentVars[8].value | string | `"regional"` |  |
| aws-eks-asg-rolling-update-handler.image.repository | string | `"twinproduction/aws-eks-asg-rolling-update-handler"` |  |
| aws-eks-asg-rolling-update-handler.image.tag | string | `"v1.8.1"` |  |
| aws-eks-asg-rolling-update-handler.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| aws-eks-asg-rolling-update-handler.resources.limits.memory | string | `"128Mi"` |  |
| aws-eks-asg-rolling-update-handler.resources.requests.cpu | string | `"10m"` |  |
| aws-eks-asg-rolling-update-handler.resources.requests.memory | string | `"32Mi"` |  |
| aws-eks-asg-rolling-update-handler.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-eks-asg-rolling-update-handler.tolerations[0].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| aws-node-termination-handler.checkASGTagBeforeDraining | bool | `false` |  |
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
| aws-node-termination-handler.logFormatVersion | int | `2` |  |
| aws-node-termination-handler.managedTag | string | `"zdt:kubezero:nth:${ClusterName}"` | "zdt:kubezero:nth:${ClusterName}" |
| aws-node-termination-handler.metadataTries | int | `0` |  |
| aws-node-termination-handler.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| aws-node-termination-handler.podMonitor.create | bool | `false` |  |
| aws-node-termination-handler.queueURL | string | `""` | https://sqs.${AWS::Region}.amazonaws.com/${AWS::AccountId}/${ClusterName}_Nth |
| aws-node-termination-handler.rbac.pspEnabled | bool | `false` |  |
| aws-node-termination-handler.taintNode | bool | `true` |  |
| aws-node-termination-handler.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-node-termination-handler.tolerations[0].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| aws-node-termination-handler.useProviderId | bool | `true` |  |
| awsNeuron.enabled | bool | `false` |  |
| awsNeuron.image.name | string | `"public.ecr.aws/neuron/neuron-device-plugin"` |  |
| awsNeuron.image.tag | string | `"2.12.5.0"` |  |
| cluster-autoscaler.autoDiscovery.clusterName | string | `""` |  |
| cluster-autoscaler.awsRegion | string | `"us-west-2"` |  |
| cluster-autoscaler.enabled | bool | `false` |  |
| cluster-autoscaler.extraArgs.balance-similar-node-groups | bool | `true` |  |
| cluster-autoscaler.extraArgs.ignore-taint | string | `"node.cilium.io/agent-not-ready"` |  |
| cluster-autoscaler.extraArgs.scan-interval | string | `"30s"` |  |
| cluster-autoscaler.extraArgs.skip-nodes-with-local-storage | bool | `false` |  |
| cluster-autoscaler.image.repository | string | `"registry.k8s.io/autoscaling/cluster-autoscaler"` |  |
| cluster-autoscaler.image.tag | string | `"v1.26.4"` |  |
| cluster-autoscaler.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| cluster-autoscaler.podDisruptionBudget | bool | `false` |  |
| cluster-autoscaler.prometheusRule.enabled | bool | `false` |  |
| cluster-autoscaler.prometheusRule.interval | string | `"30"` |  |
| cluster-autoscaler.serviceMonitor.enabled | bool | `false` |  |
| cluster-autoscaler.serviceMonitor.interval | string | `"30s"` |  |
| cluster-autoscaler.tolerations[0].effect | string | `"NoSchedule"` |  |
| cluster-autoscaler.tolerations[0].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| clusterBackup.enabled | bool | `false` |  |
| clusterBackup.extraEnv | list | `[]` |  |
| clusterBackup.image.name | string | `"public.ecr.aws/zero-downtime/kubezero-admin"` |  |
| clusterBackup.password | string | `""` | /etc/cloudbender/clusterBackup.passphrase |
| clusterBackup.repository | string | `""` | s3:https://s3.amazonaws.com/${CFN[ConfigBucket]}/k8s/${CLUSTERNAME}/clusterBackup |
| external-dns.enabled | bool | `false` |  |
| external-dns.interval | string | `"3m"` |  |
| external-dns.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| external-dns.provider | string | `"inmemory"` |  |
| external-dns.sources[0] | string | `"service"` |  |
| external-dns.tolerations[0].effect | string | `"NoSchedule"` |  |
| external-dns.tolerations[0].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| external-dns.triggerLoopOnEvent | bool | `true` |  |
| falco-control-plane.collectors | object | `{"enabled":false}` | Disable the collectors, no syscall events to enrich with metadata. |
| falco-control-plane.controller | object | `{"deployment":{"replicas":1},"kind":"deployment"}` | Deploy Falco as a deployment. One instance of Falco is enough. Anyway the number of replicas is configurabale. |
| falco-control-plane.controller.deployment.replicas | int | `1` | Number of replicas when installing Falco using a deployment. Change it if you really know what you are doing. For more info check the section on Plugins in the README.md file. |
| falco-control-plane.driver | object | `{"enabled":false}` | Disable the drivers since we want to deploy only the k8saudit plugin. |
| falco-control-plane.enabled | bool | `false` |  |
| falco-control-plane.falco.load_plugins[0] | string | `"k8saudit"` |  |
| falco-control-plane.falco.load_plugins[1] | string | `"json"` |  |
| falco-control-plane.falco.plugins[0].init_config.maxEventBytes | int | `1048576` |  |
| falco-control-plane.falco.plugins[0].library_path | string | `"libk8saudit.so"` |  |
| falco-control-plane.falco.plugins[0].name | string | `"k8saudit"` |  |
| falco-control-plane.falco.plugins[0].open_params | string | `"http://:9765/k8s-audit"` |  |
| falco-control-plane.falco.plugins[1].init_config | string | `""` |  |
| falco-control-plane.falco.plugins[1].library_path | string | `"libjson.so"` |  |
| falco-control-plane.falco.plugins[1].name | string | `"json"` |  |
| falco-control-plane.falco.rules_file[0] | string | `"/etc/falco/k8s_audit_rules.yaml"` |  |
| falco-control-plane.falco.rules_file[1] | string | `"/etc/falco/rules.d"` |  |
| falco-control-plane.falcoctl.artifact.follow.enabled | bool | `true` | Enable the sidecar container. We do not support it yet for plugins. It is used only for rules feed such as k8saudit-rules rules. |
| falco-control-plane.falcoctl.artifact.install.enabled | bool | `true` | Enable the init container. We do not recommend installing (or following) plugins for security reasons since they are executable objects. |
| falco-control-plane.falcoctl.config.artifact.follow.refs | list | `["k8saudit-rules:0.6"]` | List of artifacts to be followed by the falcoctl sidecar container. Only rulesfiles, we do no recommend plugins for security reasonts since they are executable objects. |
| falco-control-plane.falcoctl.config.artifact.install.refs | list | `["k8saudit-rules:0.6"]` | List of artifacts to be installed by the falcoctl init container. Only rulesfiles, we do no recommend plugins for security reasonts since they are executable objects. |
| falco-control-plane.falcoctl.config.artifact.install.resolveDeps | bool | `false` | Do not resolve the depenencies for artifacts. By default is true, but for our use case we disable it. |
| falco-control-plane.fullnameOverride | string | `"falco-control-plane"` |  |
| falco-control-plane.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| falco-control-plane.services[0].name | string | `"k8saudit-webhook"` |  |
| falco-control-plane.services[0].ports[0].port | int | `9765` |  |
| falco-control-plane.services[0].ports[0].protocol | string | `"TCP"` |  |
| forseti.aws.iamRoleArn | string | `""` | "arn:aws:iam::${AWS::AccountId}:role/${AWS::Region}.${ClusterName}.kubezeroForseti" |
| forseti.aws.region | string | `""` |  |
| forseti.enabled | bool | `false` |  |
| forseti.image.name | string | `"public.ecr.aws/zero-downtime/forseti"` |  |
| forseti.image.tag | string | `"v0.1.2"` |  |
| fuseDevicePlugin.enabled | bool | `false` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key | string | `"node.kubernetes.io/instance-type"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator | string | `"In"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0] | string | `"g5.xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[10] | string | `"g4dn.4xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[11] | string | `"g4dn.8xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[12] | string | `"g4dn.12xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[13] | string | `"g4dn.16xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[1] | string | `"g5.2xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[2] | string | `"g5.4xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[3] | string | `"g5.8xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[4] | string | `"g5.12xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[5] | string | `"g5.16xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[6] | string | `"g5.24xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[7] | string | `"g5.48xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[8] | string | `"g4dn.xlarge"` |  |
| nvidia-device-plugin.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[9] | string | `"g4dn.2xlarge"` |  |
| nvidia-device-plugin.enabled | bool | `false` |  |
| nvidia-device-plugin.tolerations[0].effect | string | `"NoSchedule"` |  |
| nvidia-device-plugin.tolerations[0].key | string | `"nvidia.com/gpu"` |  |
| nvidia-device-plugin.tolerations[0].operator | string | `"Exists"` |  |
| nvidia-device-plugin.tolerations[1].effect | string | `"NoSchedule"` |  |
| nvidia-device-plugin.tolerations[1].key | string | `"kubezero-workergroup"` |  |
| nvidia-device-plugin.tolerations[1].operator | string | `"Exists"` |  |
| sealed-secrets.enabled | bool | `false` |  |
| sealed-secrets.fullnameOverride | string | `"sealed-secrets-controller"` |  |
| sealed-secrets.keyrenewperiod | string | `"0"` |  |
| sealed-secrets.metrics.serviceMonitor.enabled | bool | `false` |  |
| sealed-secrets.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| sealed-secrets.resources.limits.memory | string | `"128Mi"` |  |
| sealed-secrets.resources.requests.cpu | string | `"10m"` |  |
| sealed-secrets.resources.requests.memory | string | `"24Mi"` |  |
| sealed-secrets.tolerations[0].effect | string | `"NoSchedule"` |  |
| sealed-secrets.tolerations[0].key | string | `"node-role.kubernetes.io/control-plane"` |  |
