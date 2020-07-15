kubezero-istio
==============
KubeZero Umbrella Chart for Istio

Installs Istio Operator and KubeZero Istio profile


Current chart version is `0.1.3`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
|  | istio-operator | >= 1.6 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.1 |

## KubeZero default configuration
- mapped istio-operator to run on the controller nodes only

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| istio-operator.hub | string | `"docker.io/istio"` |  |
| istio-operator.tag | string | `"1.6.5"` |  |

## Resources

- https://istio.io/latest/docs/setup/install/standalone-operator/
