kubezero-calico
===============
KubeZero Umbrella Chart for Calico

Current chart version is `0.1.3`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.1 |

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


## Resources

- Grafana Dashboard: https://grafana.com/grafana/dashboards/12175
