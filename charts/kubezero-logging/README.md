kubezero-logging
================
KubeZero Umbrella Chart for complete EFK stack

Current chart version is `0.0.1`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Changes from upstream
### ECK
- Operator mapped to controller nodes

### ElasticSearch

- Installed Plugins:
    - repository-s3
    - elasticsearch-prometheus-exporter

- [Cross AZ Zone awareness](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-advanced-node-scheduling.html#k8s-availability-zone-awareness) is implemented via nodeSets

## Manual tasks ATM

-  Install index template
- setup Kibana
- create `logstash-*` Index Pattern

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| es.replicas | int | `2` |  |
| es.storage.class | string | `"local-sc-xfs"` |  |
| es.storage.size | string | `"16Gi"` |  |
| fullnameOverride | string | `"logging"` |  |
| kibana.replicas | int | `1` |  |
| version | string | `"7.6.0"` |  |

## Resources:

- https://www.elastic.co/downloads/elastic-cloud-kubernetes
- https://github.com/elastic/cloud-on-k8s
