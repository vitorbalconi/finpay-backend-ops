{{- define "finpay-backend.name" -}}
finpay-backend
{{- end }}

{{- define "finpay-backend.fullname" -}}
{{- if contains (include "finpay-backend.name" .) .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "finpay-backend.name" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}
{{- end }}

{{- define "finpay-backend.labels" -}}
app.kubernetes.io/name: {{ include "finpay-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end }}

{{- define "finpay-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "finpay-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "finpay-backend.image" -}}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- end }}
