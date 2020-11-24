# istio-discovery

![Version: 1.2.0](https://img.shields.io/badge/Version-1.2.0-informational?style=flat-square) ![AppVersion: 1.2.0](https://img.shields.io/badge/AppVersion-1.2.0-informational?style=flat-square)

Helm chart for istio control plane

## Source Code

* <http://github.com/istio/istio>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.caAddress | string | `""` |  |
| global.centralIstiod | bool | `false` |  |
| global.defaultPodDisruptionBudget.enabled | bool | `true` |  |
| global.defaultResources.requests.cpu | string | `"10m"` |  |
| global.externalIstiod | bool | `false` |  |
| global.hub | string | `"gcr.io/istio-testing"` |  |
| global.imagePullPolicy | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.istioNamespace | string | `"istio-system"` |  |
| global.istiod.enableAnalysis | bool | `false` |  |
| global.jwtPolicy | string | `"third-party-jwt"` |  |
| global.logAsJson | bool | `false` |  |
| global.logging.level | string | `"default:info"` |  |
| global.meshID | string | `""` |  |
| global.meshNetworks | object | `{}` |  |
| global.mountMtlsCerts | bool | `false` |  |
| global.multiCluster.clusterName | string | `""` |  |
| global.multiCluster.enabled | bool | `false` |  |
| global.network | string | `""` |  |
| global.omitSidecarInjectorConfigMap | bool | `false` |  |
| global.oneNamespace | bool | `false` |  |
| global.operatorManageWebhooks | bool | `false` |  |
| global.pilotCertProvider | string | `"istiod"` |  |
| global.priorityClassName | string | `""` |  |
| global.proxy.autoInject | string | `"enabled"` |  |
| global.proxy.clusterDomain | string | `"cluster.local"` |  |
| global.proxy.componentLogLevel | string | `"misc:error"` |  |
| global.proxy.enableCoreDump | bool | `false` |  |
| global.proxy.excludeIPRanges | string | `""` |  |
| global.proxy.excludeInboundPorts | string | `""` |  |
| global.proxy.excludeOutboundPorts | string | `""` |  |
| global.proxy.holdApplicationUntilProxyStarts | bool | `false` |  |
| global.proxy.image | string | `"proxyv2"` |  |
| global.proxy.includeIPRanges | string | `"*"` |  |
| global.proxy.logLevel | string | `"warning"` |  |
| global.proxy.privileged | bool | `false` |  |
| global.proxy.readinessFailureThreshold | int | `30` |  |
| global.proxy.readinessInitialDelaySeconds | int | `1` |  |
| global.proxy.readinessPeriodSeconds | int | `2` |  |
| global.proxy.resources.limits.cpu | string | `"2000m"` |  |
| global.proxy.resources.limits.memory | string | `"1024Mi"` |  |
| global.proxy.resources.requests.cpu | string | `"100m"` |  |
| global.proxy.resources.requests.memory | string | `"128Mi"` |  |
| global.proxy.statusPort | int | `15020` |  |
| global.proxy.tracer | string | `"zipkin"` |  |
| global.proxy_init.image | string | `"proxyv2"` |  |
| global.proxy_init.resources.limits.cpu | string | `"2000m"` |  |
| global.proxy_init.resources.limits.memory | string | `"1024Mi"` |  |
| global.proxy_init.resources.requests.cpu | string | `"10m"` |  |
| global.proxy_init.resources.requests.memory | string | `"10Mi"` |  |
| global.remotePilotAddress | string | `""` |  |
| global.sds.token.aud | string | `"istio-ca"` |  |
| global.sts.servicePort | int | `0` |  |
| global.tag | string | `"latest"` |  |
| global.tracer.datadog.address | string | `"$(HOST_IP):8126"` |  |
| global.tracer.lightstep.accessToken | string | `""` |  |
| global.tracer.lightstep.address | string | `""` |  |
| global.tracer.stackdriver.debug | bool | `false` |  |
| global.tracer.stackdriver.maxNumberOfAnnotations | int | `200` |  |
| global.tracer.stackdriver.maxNumberOfAttributes | int | `200` |  |
| global.tracer.stackdriver.maxNumberOfMessageEvents | int | `200` |  |
| global.tracer.zipkin.address | string | `""` |  |
| global.trustDomain | string | `""` |  |
| global.useMCP | bool | `false` |  |
| istiodRemote.injectionURL | string | `""` |  |
| meshConfig.defaultConfig.proxyMetadata.DNS_AGENT | string | `""` |  |
| meshConfig.rootNamespace | string | `"istio-system"` |  |
| ownerName | string | `""` |  |
| pilot.autoscaleEnabled | bool | `true` |  |
| pilot.autoscaleMax | int | `5` |  |
| pilot.autoscaleMin | int | `1` |  |
| pilot.configMap | bool | `true` |  |
| pilot.configSource.subscribedResources | list | `[]` |  |
| pilot.cpu.targetAverageUtilization | int | `80` |  |
| pilot.deploymentLabels | object | `{}` |  |
| pilot.enableProtocolSniffingForInbound | bool | `true` |  |
| pilot.enableProtocolSniffingForOutbound | bool | `true` |  |
| pilot.env | object | `{}` |  |
| pilot.hub | string | `""` |  |
| pilot.image | string | `"pilot"` |  |
| pilot.jwksResolverExtraRootCA | string | `""` |  |
| pilot.keepaliveMaxServerConnectionAge | string | `"30m"` |  |
| pilot.nodeSelector | object | `{}` |  |
| pilot.plugins | list | `[]` |  |
| pilot.podAnnotations | object | `{}` |  |
| pilot.replicaCount | int | `1` |  |
| pilot.resources.requests.cpu | string | `"500m"` |  |
| pilot.resources.requests.memory | string | `"2048Mi"` |  |
| pilot.rollingMaxSurge | string | `"100%"` |  |
| pilot.rollingMaxUnavailable | string | `"25%"` |  |
| pilot.tag | string | `""` |  |
| pilot.traceSampling | float | `1` |  |
| revision | string | `""` |  |
| sidecarInjectorWebhook.alwaysInjectSelector | list | `[]` |  |
| sidecarInjectorWebhook.enableNamespacesByDefault | bool | `false` |  |
| sidecarInjectorWebhook.injectedAnnotations | object | `{}` |  |
| sidecarInjectorWebhook.neverInjectSelector | list | `[]` |  |
| sidecarInjectorWebhook.objectSelector.autoInject | bool | `true` |  |
| sidecarInjectorWebhook.objectSelector.enabled | bool | `false` |  |
| sidecarInjectorWebhook.rewriteAppHTTPProbe | bool | `true` |  |
| telemetry.enabled | bool | `true` |  |
| telemetry.v2.accessLogPolicy.enabled | bool | `false` |  |
| telemetry.v2.accessLogPolicy.logWindowDuration | string | `"43200s"` |  |
| telemetry.v2.enabled | bool | `true` |  |
| telemetry.v2.metadataExchange.wasmEnabled | bool | `false` |  |
| telemetry.v2.prometheus.configOverride.gateway | object | `{}` |  |
| telemetry.v2.prometheus.configOverride.inboundSidecar | object | `{}` |  |
| telemetry.v2.prometheus.configOverride.outboundSidecar | object | `{}` |  |
| telemetry.v2.prometheus.enabled | bool | `true` |  |
| telemetry.v2.prometheus.wasmEnabled | bool | `false` |  |
| telemetry.v2.stackdriver.configOverride | object | `{}` |  |
| telemetry.v2.stackdriver.disableOutbound | bool | `false` |  |
| telemetry.v2.stackdriver.enabled | bool | `false` |  |
| telemetry.v2.stackdriver.logging | bool | `false` |  |
| telemetry.v2.stackdriver.monitoring | bool | `false` |  |
| telemetry.v2.stackdriver.topology | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.2.1](https://github.com/norwoodj/helm-docs/releases/v1.2.1)
