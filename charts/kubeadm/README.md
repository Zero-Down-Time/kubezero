# kubeadm

![Version: 1.20.11](https://img.shields.io/badge/Version-1.20.11-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero Kubeadm golden config

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.18.0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.allEtcdEndpoints | string | `""` |  |
| api.apiAudiences | string | `"istio-ca"` |  |
| api.endpoint | string | `"kube-api.changeme.org:6443"` |  |
| api.extraArgs | object | `{}` |  |
| api.listenPort | int | `6443` |  |
| api.serviceAccountIssuer | string | `""` |  |
| clusterName | string | `"pleasechangeme"` |  |
| domain | string | `"changeme.org"` |  |
| etcd.extraArgs | object | `{}` |  |
| etcd.nodeName | string | `"set_via_cmdline"` |  |
| highAvailable | bool | `false` |  |
| kubeAdminRole | string | `"arn:aws:iam::000000000000:role/KubernetesNode"` |  |
| listenAddress | string | `"0.0.0.0"` |  |
| platform | string | `"aws"` |  |
| protectKernelDefaults | bool | `true` |  |
| systemd | bool | `true` |  |
| workerNodeRole | string | `"arn:aws:iam::000000000000:role/KubernetesNode"` |  |

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

