# kubezero-calico

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v3.16.1](https://img.shields.io/badge/AppVersion-v3.16.1-informational?style=flat-square)

KubeZero Umbrella Chart for Calico

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.16.0`

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## KubeZero default configuration

## AWS
The setup is based on the upstream calico-vxlan config from 
`https://docs.projectcalico.org/v3.15/manifests/calico-vxlan.yaml`

### Changes

- VxLAN set to Always to not expose cluster communication to VPC 

    -> EC2 SecurityGroups still apply and only need to allow UDP 4789 for VxLAN traffic 
    -> No need to disable source/destination check on EC2 instances 
    -> Prepared for optional WireGuard encryption for all inter node traffic

- MTU set to 8941

- Removed migration init-container

- Disable BGB and BIRD health checks

- Set FELIX log level to warning

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.tag | string | `""` |  |
| installCRDs | bool | `false` |  |
| loglevel | string | `"Warning"` |  |
| mtu | int | `8941` |  |
| network | string | `"vxlan"` |  |
| prometheus | bool | `false` |  |

## Resources

- Grafana Dashboard: https://grafana.com/grafana/dashboards/12175
