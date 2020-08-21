{{- define "kubezero-app.app" }}
{{- $name := regexReplaceAll "kubezero/templates/([a-z-]*)..*" .Template.Name "${1}" }}
{{- $my_values := index .Values $name "values" }}

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ $name }}
  namespace: argocd
  labels:
{{ include "kubezero-lib.labels" . | indent 4 }}
  {{- if not ( index .Values $name "retain" ) }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  {{- end }}
spec:
  project: kubezero

  source:
    repoURL: {{ .Values.global.defaultSource.repoURL }}
    targetRevision: {{ .Values.global.defaultSource.targetRevision }}
    path: {{ .Values.global.defaultSource.pathPrefix}}charts/kubezero-{{ $name }}
    {{- if $my_values }}
    helm:
      values: |
{{- toYaml $my_values | nindent 8 }}
    {{- end }}

  destination:
    server: {{ .Values.global.defaultDestination.server }}
    namespace: {{ default "kube-system" ( index .Values $name "namespace" ) }}

  {{- if .Values.global.syncPolicy }}
  syncPolicy:
    {{- toYaml .Values.global.syncPolicy | nindent 4 }}
  {{- end }}
{{- end }}
