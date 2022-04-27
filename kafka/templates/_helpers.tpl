{{/*
Expand the name of the chart.
*/}}
{{- define "fo-kaas.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fo-kaas.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fo-kaas.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fo-kaas.labels" -}}
helm.sh/chart: {{ include "fo-kaas.chart" . }}
{{ include "fo-kaas.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fo-kaas.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fo-kaas.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fo-kaas.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fo-kaas.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
generate the host name of each route for scram listeners in order to allow multi tenancy
*/}}
{{- define "kafkahostsname.scram" -}}
{{- if .Values.kafka.listeners.usesScram }}
{{- if .Values.kafka.listeners.scram.enableRouterSharding }}
{{- $nodeCount := .Values.kafka.replicas | int}}
{{- $brokername := .Values.kafka.name -}}
{{- $domainname := .Values.kafka.domain -}}
{{range $i, $e := until $nodeCount}}
        - broker: {{$i}}
          host: {{ $brokername }}-scram{{$i}}.{{ $domainname }}
{{end}}
{{- end }}
{{- end }}
{{- end }}
