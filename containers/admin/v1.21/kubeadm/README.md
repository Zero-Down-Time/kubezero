# kubeadm

![Version: 1.21.9](https://img.shields.io/badge/Version-1.21.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero Kubeadm cluster config

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | stefan@zero-downtime.net |  |

## Requirements

Kubernetes: `>= 1.20.0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| addons.aws-node-termination-handler.enabled | bool | `false` |  |
| addons.aws-node-termination-handler.queueURL | string | `""` | arn:aws:sqs:${REGION}:${AWS_ACCOUNT_ID}:${CLUSTERNAME}_Nth |
| addons.clusterBackup.enabled | bool | `false` |  |
| addons.clusterBackup.passwordFile | string | `""` | /etc/cloudbender/clusterBackup.passphrase |
| addons.clusterBackup.repository | string | `""` | s3:https://s3.amazonaws.com/${CFN[ConfigBucket]}/k8s/${CLUSTERNAME}/clusterBackup |
| api.apiAudiences | string | `"istio-ca"` |  |
| api.awsIamAuth.enabled | bool | `false` |  |
| api.awsIamAuth.kubeAdminRole | string | `"arn:aws:iam::000000000000:role/KubernetesNode"` |  |
| api.awsIamAuth.workerNodeRole | string | `"arn:aws:iam::000000000000:role/KubernetesNode"` |  |
| api.endpoint | string | `"kube-api.changeme.org:6443"` |  |
| api.etcdServers | string | `"https://etcd:2379"` |  |
| api.extraArgs | object | `{}` |  |
| api.listenPort | int | `6443` |  |
| api.oidcEndpoint | string | `""` | s3://${CFN[ConfigBucket]}/k8s/$CLUSTERNAME |
| api.serviceAccountIssuer | string | `""` | https://s3.${REGION}.amazonaws.com/${CFN[ConfigBucket]}/k8s/$CLUSTERNAME |
| clusterName | string | `"pleasechangeme"` |  |
| domain | string | `"changeme.org"` |  |
| etcd.extraArgs | object | `{}` |  |
| etcd.nodeName | string | `"etcd"` |  |
| etcd.state | string | `"new"` |  |
| highAvailable | bool | `false` |  |
| listenAddress | string | `"0.0.0.0"` | Needs to be set to primary node IP |
| network.calico.enabled | bool | `false` |  |
| network.cilium.enabled | bool | `false` |  |
| network.multus.enabled | bool | `false` |  |
| network.multus.tag | string | `"v3.8"` |  |
| nodeName | string | `"kubezero-node"` | set to $HOSTNAME |
| protectKernelDefaults | bool | `true` |  |
| systemd | bool | `true` | Set to false for openrc, eg. on Gentoo or Alpine |

## Resources

- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/
- https://godoc.org/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2
- https://pkg.go.dev/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta3
- https://github.com/kubernetes/kubernetes/blob/master/staging/src/k8s.io/kubelet/config/v1beta1/types.go
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/control-plane-flags/
- https://godoc.org/k8s.io/kube-proxy/config/v1alpha1#KubeProxyConfiguration

- https://github.com/awslabs/amazon-eks-ami

### Etcd
- https://itnext.io/breaking-down-and-fixing-etcd-cluster-d81e35b9260d

