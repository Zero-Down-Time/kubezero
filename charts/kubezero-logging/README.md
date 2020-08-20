kubezero-logging
================
KubeZero Umbrella Chart for complete EFK stack

Current chart version is `0.2.0`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://kubernetes-charts.storage.googleapis.com/ | fluentd | 2.5.1 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Changes from upstream
### ECK
- Operator mapped to controller nodes

### ES

- SSL disabled ( Todo: provide cluster certs and setup Kibana/Fluentd to use https incl. client certs )

- Installed Plugins:
  - repository-s3
  - elasticsearch-prometheus-exporter

- [Cross AZ Zone awareness](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-advanced-node-scheduling.html#k8s-availability-zone-awareness) is implemented via nodeSets

### Kibana

- increased timeout to ES to 3 minutes
 

## Manual tasks ATM

-  Install index template
- setup Kibana
- create `logstash-*` Index Pattern


## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| elastic_password | string | `""` |  |
| es.nodeSets | list | `[]` |  |
| es.prometheus | bool | `false` |  |
| es.s3Snapshot.enabled | bool | `false` |  |
| es.s3Snapshot.iamrole | string | `""` |  |
| fluentd.configMaps."forward-input.conf" | string | `"<source>\n  @type forward\n  port 24224\n  bind 0.0.0.0\n  skip_invalid_event true\n  <transport tls>\n    cert_path /mnt/fluentd-certs/tls.crt\n    private_key_path /mnt/fluentd-certs/tls.key\n  </transport>\n  <security>\n    self_hostname \"#{ENV['HOSTNAME']}\"\n    shared_key \"#{ENV['FLUENTD_SHARED_KEY']}\"\n  </security>\n</source>\n"` |  |
| fluentd.configMaps."output.conf" | string | `"<match **>\n  @id elasticsearch\n  @type elasticsearch\n  @log_level info\n  include_tag_key true\n  id_key id\n  remove_keys id\n\n  # This pipeline incl. eg. GeoIP\n  pipeline fluentd\n\n  host \"#{ENV['OUTPUT_HOST']}\"\n  port \"#{ENV['OUTPUT_PORT']}\"\n  scheme \"#{ENV['OUTPUT_SCHEME']}\"\n  ssl_version \"#{ENV['OUTPUT_SSL_VERSION']}\"\n  ssl_verify \"#{ENV['OUTPUT_SSL_VERIFY']}\"\n  user \"#{ENV['OUTPUT_USER']}\"\n  password \"#{ENV['OUTPUT_PASSWORD']}\"\n\n  logstash_format true\n  reload_connections false\n  reconnect_on_error true\n  reload_on_failure true\n  request_timeout 15s\n\n  <buffer>\n    @type file\n    path /var/log/fluentd-buffers/kubernetes.system.buffer\n    flush_mode interval\n    flush_thread_count 2\n    flush_interval 5s\n    flush_at_shutdown true\n    retry_type exponential_backoff\n    retry_timeout 60m\n    retry_max_interval 30\n    chunk_limit_size \"#{ENV['OUTPUT_BUFFER_CHUNK_LIMIT']}\"\n    queue_limit_length \"#{ENV['OUTPUT_BUFFER_QUEUE_LIMIT']}\"\n    overflow_action drop_oldest_chunk\n  </buffer>\n</match>\n"` |  |
| fluentd.enabled | bool | `false` |  |
| fluentd.env.OUTPUT_SSL_VERIFY | string | `"false"` |  |
| fluentd.env.OUTPUT_USER | string | `"elastic"` |  |
| fluentd.extraEnvVars[0].name | string | `"OUTPUT_PASSWORD"` |  |
| fluentd.extraEnvVars[0].valueFrom.secretKeyRef.key | string | `"elastic"` |  |
| fluentd.extraEnvVars[0].valueFrom.secretKeyRef.name | string | `"logging-es-elastic-user"` |  |
| fluentd.extraEnvVars[1].name | string | `"FLUENTD_SHARED_KEY"` |  |
| fluentd.extraEnvVars[1].valueFrom.secretKeyRef.key | string | `"shared_key"` |  |
| fluentd.extraEnvVars[1].valueFrom.secretKeyRef.name | string | `"logging-fluentd-secret"` |  |
| fluentd.extraVolumeMounts[0].mountPath | string | `"/mnt/fluentd-certs"` |  |
| fluentd.extraVolumeMounts[0].name | string | `"fluentd-certs"` |  |
| fluentd.extraVolumeMounts[0].readOnly | bool | `true` |  |
| fluentd.extraVolumes[0].name | string | `"fluentd-certs"` |  |
| fluentd.extraVolumes[0].secret.secretName | string | `"fluentd-certificate"` |  |
| fluentd.istio.enabled | bool | `false` |  |
| fluentd.metrics.enabled | bool | `false` |  |
| fluentd.metrics.serviceMonitor.additionalLabels.release | string | `"metrics"` |  |
| fluentd.metrics.serviceMonitor.enabled | bool | `true` |  |
| fluentd.metrics.serviceMonitor.namespace | string | `"monitoring"` |  |
| fluentd.output.host | string | `"logging-es-http"` |  |
| fluentd.plugins.enabled | bool | `false` |  |
| fluentd.plugins.pluginsList | string | `nil` |  |
| fluentd.replicaCount | int | `2` |  |
| fluentd.service.ports[0].containerPort | int | `24224` |  |
| fluentd.service.ports[0].name | string | `"tcp-forward"` |  |
| fluentd.service.ports[0].protocol | string | `"TCP"` |  |
| fluentd.service.ports[1].containerPort | int | `9880` |  |
| fluentd.service.ports[1].name | string | `"http-fluentd"` |  |
| fluentd.service.ports[1].protocol | string | `"TCP"` |  |
| fluentd.shared_key | string | `"cloudbender"` |  |
| kibana.count | int | `1` |  |
| kibana.istio.enabled | bool | `false` |  |
| kibana.istio.gateway | string | `"istio-system/ingressgateway"` |  |
| kibana.istio.url | string | `""` |  |
| version | string | `"7.8.1"` |  |

## Resources:

- https://www.elastic.co/downloads/elastic-cloud-kubernetes
- https://github.com/elastic/cloud-on-k8s
