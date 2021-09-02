# kubezero-addons

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for various optional cluster addons

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.18.0`

| Repository | Name | Version |
|------------|------|---------|
| https://metallb.github.io/metallb | metallb | 0.10.2 |

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
| fuseDevicePlugin.enabled | bool | `false` |  |
| k8sEcrLoginRenew.enabled | bool | `false` |  |
| metallb.configInline | object | `{}` |  |
| metallb.controller.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| metallb.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| metallb.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| metallb.enabled | bool | `false` |  |
| metallb.psp.create | bool | `false` |  |
