kubezero-istio
==============
KubeZero Umbrella Chart for Istio

Installs Istio Operator and KubeZero Istio profile


Current chart version is `0.1.0`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
|  | istio-operator | = 1.6 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.1 |

## KubeZero default configuration
- mapped istio-operator to run on the controller nodes only


## Resources

- https://istio.io/latest/docs/setup/install/standalone-operator/