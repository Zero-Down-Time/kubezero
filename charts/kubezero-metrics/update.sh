#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

#login_ecr_public
update_helm

get_extract_chart kube-prometheus-stack

# Add ArgoCD annotations due to size
for f in charts/kube-prometheus-stack/charts/crds/crds/crd-alertmanagerconfigs.yaml \
  charts/kube-prometheus-stack/charts/crds/crds/crd-alertmanagers.yaml \
  charts/kube-prometheus-stack/charts/crds/crds/crd-podmonitors.yaml \
  charts/kube-prometheus-stack/charts/crds/crds/crd-probes.yaml \
  charts/kube-prometheus-stack/charts/crds/crds/crd-prometheusagents.yaml \
  charts/kube-prometheus-stack/charts/crds/crds/crd-prometheuses.yaml \
  charts/kube-prometheus-stack/charts/crds/crds/crd-prometheusrules.yaml \
  charts/kube-prometheus-stack/charts/crds/crds/crd-scrapeconfigs.yaml \
  charts/kube-prometheus-stack/charts/crds/crds/crd-servicemonitors.yaml \
  charts/kube-prometheus-stack/charts/crds/crds/crd-thanosrulers.yaml; do
  yq -i '.metadata.annotations += {"argocd.argoproj.io/sync-options":"ServerSideApply=true"}' $f
done

# Create ZDT dashboard, alerts etc configmaps
cd jsonnet && make

../sync_grafana_dashboards.py metrics-dashboards.yaml ../templates/grafana-dashboards-metrics.yaml
../sync_grafana_dashboards.py k8s-dashboards.yaml ../templates/grafana-dashboards-k8s.yaml
../sync_grafana_dashboards.py zdt-dashboards.yaml ../templates/grafana-dashboards-zdt.yaml

../sync_prometheus_rules.py k8s-rules.yaml ../templates/rules
cd -

# Delete not used upstream dashboards or rules
rm -rf charts/kube-prometheus-stack/templates/grafana/dashboards-1.14 charts/kube-prometheus-stack/templates/prometheus/rules-1.14

update_docs
