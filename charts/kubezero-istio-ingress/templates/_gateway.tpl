{{- define "gatewayServers" }}

{{- range $port := .ports }}
{{- if not $port.noGateway }}

{{- $eachCert := false }}
{{- if $port.tls }}
{{- if not $port.tls.httpsRedirect }}
{{- $eachCert = true }}
{{- end }}
{{- end }}

{{- if $eachCert }}
{{- range $cert := $.certificates }}
- port:
    number: {{ $port.port }}
    name: {{ $port.name }}
    protocol: {{ default "TCP" $port.gatewayProtocol }}
  tls:
    credentialName: {{ $cert.name }}
    {{- toYaml $port.tls | nindent 4 }}
  hosts:
  {{- toYaml $cert.dnsNames | nindent 2 }}
{{- end }}
{{- else }}
- port:
    number: {{ $port.port }}
    name: {{ $port.name }}
    protocol: {{ default "TCP" $port.gatewayProtocol }}
  {{- with $port.tls }}
  tls:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  hosts:
  {{- range $cert := $.certificates }}
  {{- toYaml $cert.dnsNames | nindent 2 }}
  {{- end }}
{{- end }}
{{- end }}

{{- end }}
{{- end }}
