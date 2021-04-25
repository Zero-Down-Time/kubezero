#!/usr/bin/env python3

import sys
import json
import yaml
import requests
import textwrap
import io
import gzip
import base64

config_file = sys.argv[1]
configmap_file = sys.argv[2]


# read config file
with open(config_file, 'r') as yaml_contents:
    config = yaml.safe_load(yaml_contents.read())


if 'condition' in config:
    configmap = '''{{- if %(condition)s }}
''' % config
else:
    configmap = ''

# Base configmap for KubeZero
configmap += '''apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ printf "%%s-%%s" (include "kubezero-lib.fullname" $) "%(configmap)s" | trunc 63 | trimSuffix "-" }}
  namespace: {{ .Release.Namespace }}
  labels:
    grafana_dashboard: "1"
{{ include "kubezero-lib.labels" . | indent 4 }}
''' % config

# Put all dashboards into a folder ?
if 'folder' in config:
    configmap += '''  annotations:
    k8s-sidecar-target-directory: %(folder)s
''' % config

# compress ?
if 'gzip' in config and config['gzip']:
    configmap += '''binaryData:
'''
else:
    configmap += '''data:
'''

for b in config['dashboards']:
    response = requests.get(b['url'])
    if response.status_code != 200:
        print('Skipping the file, response code %s not equals 200' % response.status_code)
        continue
    raw_text = response.text

    obj = json.loads(raw_text)

    # Customize each dashboard
   
    # Set default tim in all charts to 1h
    obj['time'] = { "from": "now-1h", "to": "now" }
    obj['refresh'] = "30s"

    if 'tags' in b:
      obj['tags'] = b['tags']

    text = json.dumps(obj, indent=2)
    text = text.replace("{{", "{{`{{").replace("}}", "}}`}}").replace("{{`{{", "{{`{{`}}").replace("}}`}}", "{{`}}`}}")

    if 'gzip' in config and config['gzip']:
        # compress and base64 encode
        buf = io.BytesIO()
        f = gzip.GzipFile(mode='w', fileobj=buf, mtime=0)
        f.write(text.encode())
        f.close()

        textb64 = base64.b64encode(buf.getvalue()).decode('utf-8')
        textb64 = textwrap.indent(textb64, ' '*4)
        configmap += '''  %(name)s.json.gz:
''' % b
        configmap += textb64+'\n'
    else:
        text = textwrap.indent(text, ' '*4)
        configmap += '''  %(name)s.json:
''' % b
        configmap += text+'\n'


if 'condition' in config:
    configmap += '{{- end }}'+'\n'

# Write Configmap
with open(configmap_file, 'w') as f:
    f.write(configmap)
