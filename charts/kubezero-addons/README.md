# kubezero-addons

![Version: 0.2.1](https://img.shields.io/badge/Version-0.2.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for various optional cluster addons

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | stefan@zero-downtime.net |  |

## Requirements

Kubernetes: `>= 1.20.0`

| Repository | Name | Version |
|------------|------|---------|
|  | aws-node-termination-handler | 0.16.0 |

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
| aws-node-termination-handler.enablePrometheusServer | bool | `false` |  |
| aws-node-termination-handler.enableSqsTerminationDraining | bool | `true` |  |
| aws-node-termination-handler.enabled | bool | `false` |  |
| aws-node-termination-handler.extraEnv.AWS_ROLE_ARN | string | `""` | "arn:aws:iam::${AWS::AccountId}:role/${AWS::Region}.${ClusterName}.awsNth" |
| aws-node-termination-handler.extraEnv.AWS_STS_REGIONAL_ENDPOINTS | string | `"regional"` |  |
| aws-node-termination-handler.extraEnv.AWS_WEB_IDENTITY_TOKEN_FILE | string | `"/var/run/secrets/sts.amazonaws.com/serviceaccount/token"` |  |
| aws-node-termination-handler.fullnameOverride | string | `"aws-node-termination-handler"` |  |
| aws-node-termination-handler.jsonLogging | bool | `true` |  |
| aws-node-termination-handler.metadataTries | int | `0` |  |
| aws-node-termination-handler.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| aws-node-termination-handler.podMonitor.create | bool | `false` |  |
| aws-node-termination-handler.queueURL | string | `""` | https://sqs.${AWS::Region}.amazonaws.com/${AWS::AccountId}/${ClusterName}_Nth |
| aws-node-termination-handler.rbac.pspEnabled | bool | `false` |  |
| aws-node-termination-handler.taintNode | bool | `true` |  |
| aws-node-termination-handler.tolerations[0].effect | string | `"NoSchedule"` |  |
| aws-node-termination-handler.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| clusterBackup.enabled | bool | `false` |  |
| clusterBackup.image.name | string | `"public.ecr.aws/zero-downtime/kubezero-admin"` |  |
| clusterBackup.image.tag | string | `"v1.21.7"` |  |
| clusterBackup.password | string | `""` |  |
| clusterBackup.repository | string | `""` |  |
| fuseDevicePlugin.enabled | bool | `false` |  |
| k8sEcrLoginRenew.enabled | bool | `false` |  |
