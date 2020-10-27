# kubezero-logging

![Version: 0.4.1](https://img.shields.io/badge/Version-0.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.2.1](https://img.shields.io/badge/AppVersion-1.2.1-informational?style=flat-square)

KubeZero Umbrella Chart for complete EFK stack

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.16.0`

| Repository | Name | Version |
|------------|------|---------|
| https://kubernetes-charts.storage.googleapis.com/ | fluentd | 2.5.1 |
| https://zero-down-time.github.io/kubezero/ | fluent-bit | 0.7.2 |
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

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| elastic_password | string | `""` |  |
| es.nodeSets | list | `[]` |  |
| es.prometheus | bool | `false` |  |
| es.s3Snapshot.enabled | bool | `false` |  |
| es.s3Snapshot.iamrole | string | `""` |  |
| fluent-bit.config.customParsers | string | `"[PARSER]\n    Name cri-log\n    Format regex\n    Regex ^(?<time>[^ ]+) (?<stream>stdout|stderr) (?<logtag>[^ ]*) (?<log>.*)$\n    Time_Key    time\n    Time_Format %Y-%m-%dT%H:%M:%S.%L%z\n"` |  |
| fluent-bit.config.filters | string | `"[FILTER]\n    Name    lua\n    Match   cri.*\n    script  /fluent-bit/etc/functions.lua\n    call    reassemble_cri_logs\n\n[FILTER]\n    Name kubernetes\n    Match cri.*\n    Merge_Log On\n    Merge_Log_Key kube\n    Kube_Tag_Prefix cri.var.log.containers.\n    Keep_Log Off\n    K8S-Logging.Parser Off\n    K8S-Logging.Exclude Off\n\n[FILTER]\n    Name rewrite_tag\n    Match cri.*\n    Emitter_Name kube_tag_rewriter\n    Rule logtag F kube.$kubernetes['namespace_name'].$kubernetes['container_name'] false\n\n[FILTER]\n    Name    lua\n    Match   kube.*\n    script  /fluent-bit/etc/functions.lua\n    call    nest_k8s_ns\n"` |  |
| fluent-bit.config.inputs | string | `"[INPUT]\n    Name tail\n    Path /var/log/containers/*.log\n    Parser cri-log\n    Tag cri.*\n    Mem_Buf_Limit 16MB\n    Skip_Long_Lines On\n    Refresh_Interval 10\n    DB /var/log/flb_kube.db\n    DB.Sync Normal\n"` |  |
| fluent-bit.config.lua | string | `"local reassemble_state = {}\n\nfunction reassemble_cri_logs(tag, timestamp, record)\n   local reassemble_key = tag\n   if record.logtag == 'P' then\n      reassemble_state[reassemble_key] = reassemble_state[reassemble_key] or \"\" .. record.log\n      return -1, 0, 0\n   end\n   record.log = reassemble_state[reassemble_key] or \"\" .. (record.log or \"\")\n   reassemble_state[reassemble_key] = nil\n   return 1, timestamp, record\nend\n\nfunction nest_k8s_ns(tag, timestamp, record)\n    if not record['kubernetes']['namespace_name'] then\n        return 0, 0, 0\n    end\n    new_record = {}\n    for key, val in pairs(record) do\n        if key == 'kube' then\n            new_record[key] = {}\n            new_record[key][record['kubernetes']['namespace_name']] = record[key]\n        else\n            new_record[key] = record[key]\n        end\n    end\n    return 1, timestamp, new_record\nend\n"` |  |
| fluent-bit.config.outputs | string | `"[OUTPUT]\n    Match *\n    Name forward\n    Host logging-fluentd\n    Port 24224\n    Shared_Key cloudbender\n    Send_options true\n    Require_ack_response true\n"` |  |
| fluent-bit.config.service | string | `"[SERVICE]\n    Flush 1\n    Daemon Off\n    Log_Level warn\n    Parsers_File parsers.conf\n    Parsers_File custom_parsers.conf\n    HTTP_Server On\n    HTTP_Listen 0.0.0.0\n    HTTP_Port 2020\n"` |  |
| fluent-bit.enabled | bool | `false` |  |
| fluent-bit.serviceMonitor.enabled | bool | `true` |  |
| fluent-bit.serviceMonitor.namespace | string | `"monitoring"` |  |
| fluent-bit.serviceMonitor.selector.release | string | `"metrics"` |  |
| fluent-bit.test.enabled | bool | `false` |  |
| fluent-bit.tolerations[0].effect | string | `"NoSchedule"` |  |
| fluent-bit.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| fluentd.configMaps."filter.conf" | string | `"<filter disabled.kube.**>\n  @type parser\n  key_name message\n  remove_key_name_field true\n  reserve_data true\n  reserve_time true\n  # inject_key_prefix message_json.\n  emit_invalid_record_to_error false\n  <parse>\n    @type json\n  </parse>\n</filter>\n"` |  |
| fluentd.configMaps."forward-input.conf" | string | `"<source>\n  @type forward\n  port 24224\n  bind 0.0.0.0\n  skip_invalid_event true\n  send_keepalive_packet true\n  <security>\n    self_hostname \"#{ENV['HOSTNAME']}\"\n    shared_key \"#{ENV['FLUENTD_SHARED_KEY']}\"\n  </security>\n</source>\n"` |  |
| fluentd.configMaps."general.conf" | string | `"<label @FLUENT_LOG>\n  <match **>\n    @type null\n  </match>\n</label>\n<source>\n  @type http\n  port 9880\n  bind 0.0.0.0\n  keepalive_timeout 30\n</source>\n<source>\n  @type monitor_agent\n  bind 0.0.0.0\n  port 24220\n  tag fluentd.monitor.metrics\n</source>\n"` |  |
| fluentd.configMaps."output.conf" | string | `"<match **>\n  @id elasticsearch\n  @type elasticsearch\n  @log_level info\n  include_tag_key true\n  id_key id\n  remove_keys id\n\n  # KubeZero pipeline incl. GeoIP etc.\n  # pipeline fluentd\n\n  host \"#{ENV['OUTPUT_HOST']}\"\n  port \"#{ENV['OUTPUT_PORT']}\"\n  scheme \"#{ENV['OUTPUT_SCHEME']}\"\n  ssl_version \"#{ENV['OUTPUT_SSL_VERSION']}\"\n  ssl_verify \"#{ENV['OUTPUT_SSL_VERIFY']}\"\n  user \"#{ENV['OUTPUT_USER']}\"\n  password \"#{ENV['OUTPUT_PASSWORD']}\"\n\n  log_es_400_reason\n  logstash_format true\n  reconnect_on_error true\n  # reload_on_failure true\n  request_timeout 15s\n  suppress_type_name true\n\n  <buffer tag>\n    @type file_single\n    path /var/log/fluentd-buffers/kubernetes.system.buffer\n    flush_mode interval\n    flush_thread_count 2\n    flush_interval 30s\n    flush_at_shutdown true\n    retry_type exponential_backoff\n    retry_timeout 60m\n    overflow_action drop_oldest_chunk\n  </buffer>\n</match>\n"` |  |
| fluentd.enabled | bool | `false` |  |
| fluentd.env.OUTPUT_SSL_VERIFY | string | `"false"` |  |
| fluentd.env.OUTPUT_USER | string | `"elastic"` |  |
| fluentd.extraEnvVars[0].name | string | `"OUTPUT_PASSWORD"` |  |
| fluentd.extraEnvVars[0].valueFrom.secretKeyRef.key | string | `"elastic"` |  |
| fluentd.extraEnvVars[0].valueFrom.secretKeyRef.name | string | `"logging-es-elastic-user"` |  |
| fluentd.extraEnvVars[1].name | string | `"FLUENTD_SHARED_KEY"` |  |
| fluentd.extraEnvVars[1].valueFrom.secretKeyRef.key | string | `"shared_key"` |  |
| fluentd.extraEnvVars[1].valueFrom.secretKeyRef.name | string | `"logging-fluentd-secret"` |  |
| fluentd.image.repository | string | `"quay.io/fluentd_elasticsearch/fluentd"` |  |
| fluentd.image.tag | string | `"v2.9.0"` |  |
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
