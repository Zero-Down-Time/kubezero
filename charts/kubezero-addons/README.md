# kubezero-addons

![Version: 0.5.0](https://img.shields.io/badge/Version-0.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.22.8](https://img.shields.io/badge/AppVersion-v1.22.8-informational?style=flat-square)

KubeZero umbrella chart for various optional cluster addons

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.20.0`

| Repository | Name | Version |
|------------|------|---------|
|  | aws-node-termination-handler | 0.18.0 |
| https://kubernetes-sigs.github.io/external-dns/ | external-dns | 1.7.1 |

# MetalLB   
   
# device-plugins   
   
# k8s-ecr-login-renew   
   
## IAM setup   
 - Create IAM user for ECR read-only access and attach the following managed policy: `AmazonEC2ContainerRegistryReadOnly`   
 - create AWS credentials for the IAM users   
   
## Kubernetes secret   
Create secret with the IAM user credential for ecr-renew to use, using the credentials from the previous step:   
`kubectl create secret -n kube-system generic ecr-renew-cred --from-literal=AWS_REGION=<AWS_REGION> --from-literal=AWS_ACCESS_KEY_ID=<AWS_SECRET_ID> --from-literal=AWS_SECRET_ACCESS_KEY=<AWS_SECRET_KEY>`   
   
## Resources   
- https://github.com/nabsul/k8s-ecr-login-renew

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws-node-termination-handler.deleteLocalData | bool | `true` |  |
| aws-node-termination-handler.emitKubernetesEvents | bool | `true` |  |
| aws-node-termination-handler.enableProbesServer | bool | `true` |  |
| aws-node-termination-handler.enablePrometheusServer | bool | `false` |  |
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
| aws-node-termination-handler.managedAsgTag | string | `"aws-node-termination-handler/managed"` | "aws-node-termination-handler/${ClusterName}" |
| aws-node-termination-handler.metadataTries | int | `0` |  |
| aws-node-termination-handler.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| aws-node-termination-handler.podMonitor.create | bool | `false` |  |
| aws-node-termination-handler.queueURL | string | `""` | https://sqs.${AWS::Region}.amazonaws.com/${AWS::AccountId}/${ClusterName}_Nth |
| aws-node-termination-handler.rbac.pspEnabled | bool | `false` |  |
| aws-node-termination-handler.taintNode | bool | `true` |  |
| aws-node-termination-handler.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-node-termination-handler.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| clusterBackup.enabled | bool | `false` |  |
| clusterBackup.extraEnv | list | `[]` |  |
| clusterBackup.image.name | string | `"public.ecr.aws/zero-downtime/kubezero-admin"` |  |
| clusterBackup.password | string | `""` |  |
| clusterBackup.repository | string | `""` |  |
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
| external-dns.triggerLoopOnEvent | bool | `true` |  |
| forseti.aws.iamRoleArn | string | `""` | "arn:aws:iam::${AWS::AccountId}:role/${AWS::Region}.${ClusterName}.kubezeroForseti" |
| forseti.aws.region | string | `""` |  |
| forseti.enabled | bool | `false` |  |
| forseti.image.name | string | `"public.ecr.aws/zero-downtime/forseti"` |  |
| forseti.image.tag | string | `"v0.1.2"` |  |
| fuseDevicePlugin.enabled | bool | `false` |  |
| k8sEcrLoginRenew.enabled | bool | `false` |  |
