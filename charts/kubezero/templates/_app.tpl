{{- define "kubezero-app.app" }}
{{- $name := regexReplaceAll "kubezero/templates/([a-z-]*)..*" .Template.Name "${1}" }}

{{- if index .Values $name "enabled" }}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ $name }}
  namespace: argocd
  labels:
    {{- include "kubezero-lib.labels" . | nindent 4 }}
  {{- if not ( index .Values $name "retain" ) }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  {{- end }}
spec:
  project: kubezero

  source:
    chart: kubezero-{{ $name }}
    repoURL: {{ .Values.kubezero.repoURL }}
    targetRevision: {{ default .Values.kubezero.targetRevision ( index .Values $name "targetRevision" ) | quote }}
    helm:
      values: |
{{- include (print $name "-values") $ | nindent 8 }}

  destination:
    server: {{ .Values.kubezero.server }}
    namespace: {{ default "kube-system" ( index .Values $name "namespace" ) }}

  {{- with .Values.kubezero.syncPolicy }}
  syncPolicy:
    {{- toYaml . | nindent 4 }}
  {{- end }}

{{- include (print $name "-argo") $ }}
{{- end }}

{{- end }}
