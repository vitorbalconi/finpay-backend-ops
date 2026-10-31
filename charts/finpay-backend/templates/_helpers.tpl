{{- define "finpay-backend.name" -}}
finpay-backend
{{- end }}

{{- define "finpay-backend.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "finpay-backend.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "finpay-backend.labels" -}}
app.kubernetes.io/name: {{ include "finpay-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.appVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end }}

{{- define "finpay-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "finpay-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "finpay-backend.image" -}}
{{- if .Values.image.digest -}}
{{- printf "%s@sha256:%s" .Values.image.repository (.Values.image.digest | trimPrefix "sha256:") -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end }}
