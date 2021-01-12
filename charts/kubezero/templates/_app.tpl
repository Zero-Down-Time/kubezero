{{- define "kubezero-app.app" }}
{{- $name := regexReplaceAll "kubezero/templates/([a-z-]*)..*" .Template.Name "${1}" }}

{{- if and .Values.argo ( index .Values $name "enabled" ) }}
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
    repoURL: {{ .Values.global.kubezero.repoURL }}
    targetRevision: {{ .Values.global.kubezero.targetRevision }}
    path: {{ .Values.global.kubezero.pathPrefix}}charts/kubezero-{{ $name }}
    helm:
      values: |
{{- include (print $name "-values") $ | nindent 8 }}

  destination:
    server: {{ .Values.global.kubezero.server }}
    namespace: {{ default "kube-system" ( index .Values $name "namespace" ) }}

  {{- with .Values.global.kubezero.syncPolicy }}
  syncPolicy:
    {{- toYaml . | nindent 4 }}
  {{- end }}

{{- include (print $name "-argo") $ }}
{{- end }}

{{- end }}
