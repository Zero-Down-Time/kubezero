#!/bin/bash

# get current values, argo app over cm
get_kubezero_values

# tumble new config through migrate.py
migrate_argo_values.py < "$WORKDIR"/kubezero-values.yaml > "$WORKDIR"/new-kubezero-values.yaml

# Update kubezero-values CM
kubectl get cm -n kube-system kubezero-values -o=yaml | \
  yq e '.data."values.yaml" |= load_str("/tmp/kubezero/new-kubezero-values.yaml")' | \
  kubectl replace -f -

# update argo app
kubectl get application kubezero -n argocd -o yaml | \
  kubezero_chart_version=$(yq .version /charts/kubezero/Chart.yaml) \
  yq '.spec.source.helm.values |= load_str("/tmp/kubezero/new-kubezero-values.yaml") | .spec.source.targetRevision = strenv(kubezero_chart_version)' | \
  kubectl apply -f -

# finally remove annotation to allow argo to sync again
kubectl patch app kubezero -n argocd --type json -p='[{"op": "remove", "path": "/metadata/annotations"}]'
