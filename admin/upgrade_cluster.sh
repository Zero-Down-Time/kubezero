#!/bin/bash
set -eE
set -o pipefail

ARGO_APP=${1:-/tmp/new-kubezero-argoapp.yaml}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# shellcheck disable=SC1091
[ -n "$DEBUG" ] && set -x

. "$SCRIPT_DIR"/libhelm.sh

echo "Checking that all pods in kube-system are running ..."
waitSystemPodsRunning

argo_used && disable_argo

#all_nodes_upgrade ""

control_plane_upgrade kubeadm_upgrade

#echo "Adjust kubezero values as needed:"
# shellcheck disable=SC2015
#argo_used && kubectl edit app kubezero -n argocd || kubectl edit cm kubezero-values -n kube-system

# upgrade modules
control_plane_upgrade "apply_network apply_addons, apply_storage, apply_operators"

echo "Checking that all pods in kube-system are running ..."
waitSystemPodsRunning

echo "Applying remaining KubeZero modules..."

### v1.28
# - remove old argocd app, all resources will be taken over by argo.argo-cd
kubectl patch app argocd -n argocd \
    --type json \
    --patch='[ { "op": "remove", "path": "/metadata/finalizers" } ]' && \
  kubectl delete app argocd -n argocd || true

control_plane_upgrade "apply_cert-manager, apply_istio, apply_istio-ingress, apply_istio-private-ingress, apply_logging, apply_metrics, apply_telemetry, apply_argo"

# Trigger backup of upgraded cluster state
kubectl create job --from=cronjob/kubezero-backup kubezero-backup-$VERSION -n kube-system
while true; do
  kubectl wait --for=condition=complete job/kubezero-backup-$VERSION -n kube-system 2>/dev/null && kubectl delete job kubezero-backup-$VERSION -n kube-system && break
  sleep 1
done

# Final step is to commit the new argocd kubezero app
kubectl get app kubezero -n argocd -o yaml | yq 'del(.status) | del(.metadata) | del(.operation) | .metadata.name="kubezero" | .metadata.namespace="argocd"' | yq 'sort_keys(..) | .spec.source.helm.values |= (from_yaml | to_yaml)' > $ARGO_APP

echo "Please commit $ARGO_APP as the updated kubezero/application.yaml for your cluster."
echo "Then head over to ArgoCD for this cluster and sync all KubeZero modules to apply remaining upgrades."

echo "<Return> to continue and re-enable ArgoCD:"
read -r

argo_used && enable_argo
