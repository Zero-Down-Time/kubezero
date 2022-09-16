#!/bin/bash

# Migrate addons and network values from local kubeadm-values.yaml on controllers into CM
# - remove secrets from addons
# - enable cilium
        
# Create kubeadm-values CM if not available
kubectl get cm -n kube-system kubeadm-values || \
kubectl create configmap -n kube-system kubeadm-values

kubectl get cm -n kube-system kubezero-values || \
kubectl create configmap -n kube-system kubezero-values

# tweak local kubeadm for upgrade later on
yq eval -i '.global.clusterName = strenv(CLUSTERNAME) |
            .global.highAvailable = env(HIGHAVAILABLE)' \
  ${HOSTFS}/etc/kubernetes/kubeadm-values.yaml

# extract addons
yq e '.addons |
      del .clusterBackup.repository |
      del .clusterBackup.password |
      .clusterBackup.image.tag = strenv(KUBE_VERSION) |
      {"addons": .}' ${HOSTFS}/etc/kubernetes/kubeadm-values.yaml > $WORKDIR/addons-values.yaml

# extract network
yq e '.network |
      .cilium.enabled = true |
      .calico.enabled = true |
      .multus.enabled = true |
      .multus.defaultNetworks = ["cilium"] |
      .cilium.cluster.name = strenv(CLUSTERNAME) |
      {"network": .}' ${HOSTFS}/etc/kubernetes/kubeadm-values.yaml > $WORKDIR/network-values.yaml

# get current argo cd values
kubectl get application kubezero -n argocd -o yaml | yq '.spec.source.helm.values' > ${WORKDIR}/argo-values.yaml

# merge all into new CM
yq ea '. as $item ireduce ({}; . * $item ) |
       .global.clusterName = strenv(CLUSTERNAME) |
       .global.highAvailable = env(HIGHAVAILABLE)' $WORKDIR/addons-values.yaml ${WORKDIR}/network-values.yaml $WORKDIR/argo-values.yaml > $WORKDIR/kubezero-pre-values.yaml

# tumble new config via migrate.py
cat $WORKDIR/kubezero-pre-values.yaml | migrate_argo_values.py > $WORKDIR/kubezero-values.yaml

# Update kubezero-values CM
kubectl get cm -n kube-system kubezero-values -o=yaml | \
  yq e '.data."values.yaml" |= load_str("/tmp/kubezero/kubezero-values.yaml")' | \
  kubectl replace -f -


# update argo app
kubectl get application kubezero -n argocd -o yaml | \
  kubezero_chart_version=$(yq .version /charts/kubezero/Chart.yaml) \
  yq '.spec.source.helm.values |= load_str("/tmp/kubezero/kubezero-values.yaml") | .spec.source.targetRevision = strenv(kubezero_chart_version)' | \
  kubectl apply -f -

# finally remove annotation to allow argo to sync again
kubectl patch app kubezero -n argocd --type json -p='[{"op": "remove", "path": "/metadata/annotations"}]'