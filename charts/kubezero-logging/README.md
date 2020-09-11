kubezero-logging
================
KubeZero Umbrella Chart for complete EFK stack

Current chart version is `0.3.3`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://kubernetes-charts.storage.googleapis.com/ | fluentd | 2.5.1 |
| https://zero-down-time.github.io/kubezero/ | fluent-bit | 0.6.4 |
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
 
### FluentD


### Fluent-bit
- support for dedot Lua filter to replace "." with "_" for all annotations and labels
- support for api audit log

## Manual tasks ATM

- install index template
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
| fluent-bit.config.filters | string | `"[FILTER]\n    Name    lua\n    Match   kube.*\n    script  /fluent-bit/etc/functions.lua\n    call    reassemble_cri_logs\n\n[FILTER]\n    Name kubernetes\n    Match kube.*\n    Merge_Log On\n    Keep_Log Off\n    K8S-Logging.Parser On\n    K8S-Logging.Exclude On\n\n[FILTER]\n    Name    lua\n    Match   kube.*\n    script  /fluent-bit/etc/functions.lua\n    call    dedot\n"` |  |
| fluent-bit.config.inputs | string | `"[INPUT]\n    Name tail\n    Path /var/log/containers/*.log\n    Parser cri\n    Tag kube.*\n    Mem_Buf_Limit 5MB\n    Skip_Long_Lines On\n    Refresh_Interval 10\n    DB /var/log/flb_kube.db\n    DB.Sync Normal\n[INPUT]\n    Name tail\n    Path /var/log/kubernetes/audit.log\n    Parser json\n    Tag audit.api-server\n    Mem_Buf_Limit 5MB\n    Skip_Long_Lines On\n    Refresh_Interval 60\n    DB /var/log/flb_kube_audit.db\n    DB.Sync Normal\n"` |  |
| fluent-bit.config.lua | string | `"function dedot(tag, timestamp, record)\n    if record[\"kubernetes\"] == nil then\n        return 0, 0, 0\n    end\n    dedot_keys(record[\"kubernetes\"][\"annotations\"])\n    dedot_keys(record[\"kubernetes\"][\"labels\"])\n    return 1, timestamp, record\nend\n\nfunction dedot_keys(map)\n    if map == nil then\n        return\n    end\n    local new_map = {}\n    local changed_keys = {}\n    for k, v in pairs(map) do\n        local dedotted = string.gsub(k, \"%.\", \"_\")\n        if dedotted ~= k then\n            new_map[dedotted] = v\n            changed_keys[k] = true\n        end\n    end\n    for k in pairs(changed_keys) do\n        map[k] = nil\n    end\n    for k, v in pairs(new_map) do\n        map[k] = v\n    end\nend\n\nlocal reassemble_state = {}\n\nfunction reassemble_cri_logs(tag, timestamp, record)\n   -- IMPORTANT: reassemble_key must be unique for each parser stream\n   -- otherwise entries from different sources will get mixed up.\n   -- Either make sure that your parser tags satisfy this or construct\n   -- reassemble_key some other way\n   local reassemble_key = tag\n   -- if partial line, accumulate\n   if record.logtag == 'P' then\n      reassemble_state[reassemble_key] = reassemble_state[reassemble_key] or \"\" .. record.message\n      return -1, 0, 0\n   end\n   -- otherwise it's a full line, concatenate with accumulated partial lines if any\n   record.message = reassemble_state[reassemble_key] or \"\" .. (record.message or \"\")\n   reassemble_state[reassemble_key] = nil\n   return 1, timestamp, record\nend\n"` |  |
| fluent-bit.config.outputs | string | `"[OUTPUT]\n    Match *\n    Name forward\n    Host logging-fluentd\n    Port 24224\n    tls on\n    tls.verify off\n    Shared_Key cloudbender\n"` |  |
| fluent-bit.config.service | string | `"[SERVICE]\n    Flush 5\n    Daemon Off\n    Log_Level warn\n    Parsers_File parsers.conf\n    Parsers_File custom_parsers.conf\n    HTTP_Server On\n    HTTP_Listen 0.0.0.0\n    HTTP_Port 2020\n"` |  |
| fluent-bit.enabled | bool | `false` |  |
| fluent-bit.serviceMonitor.enabled | bool | `true` |  |
| fluent-bit.serviceMonitor.namespace | string | `"monitoring"` |  |
| fluent-bit.serviceMonitor.selector.release | string | `"metrics"` |  |
| fluent-bit.test.enabled | bool | `false` |  |
| fluent-bit.tolerations[0].effect | string | `"NoSchedule"` |  |
| fluent-bit.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| fluentd.configMaps."filter.conf" | string | `"<filter kube.**>\n  @type parser\n  key_name message\n  remove_key_name_field true\n  reserve_data true\n  emit_invalid_record_to_error false\n  <parse>\n    @type json\n  </parse>\n</filter>\n"` |  |
| fluentd.configMaps."forward-input.conf" | string | `"<source>\n  @type forward\n  port 24224\n  bind 0.0.0.0\n  skip_invalid_event true\n  <transport tls>\n    cert_path /mnt/fluentd-certs/tls.crt\n    private_key_path /mnt/fluentd-certs/tls.key\n  </transport>\n  <security>\n    self_hostname \"#{ENV['HOSTNAME']}\"\n    shared_key \"#{ENV['FLUENTD_SHARED_KEY']}\"\n  </security>\n</source>\n"` |  |
| fluentd.configMaps."output.conf" | string | `"<match **>\n  @id elasticsearch\n  @type elasticsearch\n  @log_level info\n  include_tag_key true\n  id_key id\n  remove_keys id\n\n  # KubeZero pipeline incl. GeoIP etc.\n  # Freaking ES jams under load and all is lost ...\n  # pipeline fluentd\n\n  host \"#{ENV['OUTPUT_HOST']}\"\n  port \"#{ENV['OUTPUT_PORT']}\"\n  scheme \"#{ENV['OUTPUT_SCHEME']}\"\n  ssl_version \"#{ENV['OUTPUT_SSL_VERSION']}\"\n  ssl_verify \"#{ENV['OUTPUT_SSL_VERIFY']}\"\n  user \"#{ENV['OUTPUT_USER']}\"\n  password \"#{ENV['OUTPUT_PASSWORD']}\"\n\n  log_es_400_reason\n  logstash_format true\n  reconnect_on_error true\n  # reload_on_failure true\n  request_timeout 15s\n  suppress_type_name true\n\n  <buffer>\n    @type file\n    path /var/log/fluentd-buffers/kubernetes.system.buffer\n    flush_mode interval\n    flush_thread_count 2\n    flush_interval 30s\n    flush_at_shutdown true\n    retry_type exponential_backoff\n    retry_timeout 60m\n    chunk_limit_size 16M\n    overflow_action drop_oldest_chunk\n  </buffer>\n</match>\n"` |  |
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
| fluentd.image.repository | string | `"quay.io/fluentd_elasticsearch/fluentd"` |  |
| fluentd.image.tag | string | `"v3.0.4"` |  |
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
- https://grafana.com/grafana/dashboards/7752
