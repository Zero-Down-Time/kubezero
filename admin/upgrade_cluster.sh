#!/bin/bash
set -eE
set -o pipefail

#VERSION="latest"
VERSION="v1.27"
ARGO_APP=${1:-/tmp/new-kubezero-argoapp.yaml}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/libhelm.sh

[ -n "$DEBUG" ] && set -x

all_nodes_upgrade() {
  CMD="$1"

  echo "Deploy all node upgrade daemonSet(busybox)"
  cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: kubezero-all-nodes-upgrade
  namespace: kube-system
  labels:
    app: kubezero-upgrade
spec:
  selector:
    matchLabels:
      name: kubezero-all-nodes-upgrade
  template:
    metadata:
      labels:
        name: kubezero-all-nodes-upgrade
    spec:
      hostNetwork: true
      hostIPC: true
      hostPID: true
      tolerations:
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      initContainers:
      - name: node-upgrade
        image: busybox
        command: ["/bin/sh"]
        args: ["-x", "-c", "$CMD" ]
        volumeMounts:
        - name: host
          mountPath: /host
        - name: hostproc
          mountPath: /hostproc
        securityContext:
          privileged: true
          capabilities:
            add: ["SYS_ADMIN"]
      containers:
      - name: node-upgrade-wait
        image: busybox
        command: ["sleep", "3600"]
      volumes:
      - name: host
        hostPath:
          path: /
          type: Directory
      - name: hostproc
        hostPath:
          path: /proc
          type: Directory
EOF

  kubectl rollout status daemonset -n kube-system kubezero-all-nodes-upgrade --timeout 300s
  kubectl delete ds kubezero-all-nodes-upgrade -n kube-system
}


control_plane_upgrade() {
  TASKS="$1"

  echo "Deploy cluster admin task: $TASKS"
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: kubezero-upgrade
  namespace: kube-system
  labels:
    app: kubezero-upgrade
spec:
  hostNetwork: true
  hostIPC: true
  hostPID: true
  containers:
  - name: kubezero-admin
    image: public.ecr.aws/zero-downtime/kubezero-admin:${VERSION}
    imagePullPolicy: Always
    command: ["kubezero.sh"]
    args: [$TASKS]
    env:
    - name: DEBUG
      value: "$DEBUG"
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    volumeMounts:
    - name: host
      mountPath: /host
    - name: workdir
      mountPath: /tmp
    securityContext:
      capabilities:
        add: ["SYS_CHROOT"]
  volumes:
  - name: host
    hostPath:
      path: /
      type: Directory
  - name: workdir
    emptyDir: {}
  nodeSelector:
    node-role.kubernetes.io/control-plane: ""
  tolerations:
  - key: node-role.kubernetes.io/control-plane
    operator: Exists
    effect: NoSchedule
  restartPolicy: Never
EOF

  kubectl wait pod kubezero-upgrade -n kube-system --timeout 120s --for=condition=initialized 2>/dev/null
  while true; do
    kubectl logs kubezero-upgrade -n kube-system -f 2>/dev/null && break
    sleep 3
  done
  kubectl delete pod kubezero-upgrade -n kube-system
}


echo "Checking that all pods in kube-system are running ..."
waitSystemPodsRunning

argo_used && disable_argo

#all_nodes_upgrade ""

control_plane_upgrade kubeadm_upgrade

#echo "Adjust kubezero values as needed:"
# shellcheck disable=SC2015
#argo_used && kubectl edit app kubezero -n argocd || kubectl edit cm kubezero-values -n kube-system

# v1.27
# We need to restore the network ready file as cilium decided to rename it
control_plane_upgrade apply_network

echo "Wait for all CNI agents to be running ..." 
kubectl rollout status ds/cilium -n kube-system --timeout=120s

all_nodes_upgrade "cd /host/etc/cni/net.d && ln -s 05-cilium.conflist 05-cilium.conf || true"
# v1.27

# now the rest
control_plane_upgrade "apply_addons, apply_storage, apply_operators"

# v1.27
# Remove legacy eck-operator as part of logging if running
kubectl delete statefulset elastic-operator -n logging || true
# v1.27

echo "Checking that all pods in kube-system are running ..."
waitSystemPodsRunning

echo "Applying remaining KubeZero modules..."

# v1.27
### Cleanup of some deprecated Istio Crds
for crd in clusterrbacconfigs.rbac.istio.io rbacconfigs.rbac.istio.io servicerolebindings.rbac.istio.io serviceroles.rbac.istio.io; do
  kubectl delete crds $crd || true
done

# Cleanup of some legacy node labels and annotations
controllers=$(kubectl get nodes -l node-role.kubernetes.io/control-plane -o json | jq .items[].metadata.name -r)
for c in $controllers; do
  for l in projectcalico.org/IPv4VXLANTunnelAddr projectcalico.org/IPv4Address; do
    kubectl annotate node $c ${l}-
  done
  kubectl label node $c topology.ebs.csi.aws.com/zone-
done

# Fix for legacy cert-manager CRDs to be upgraded
for crd_name in certificaterequests.cert-manager.io certificates.cert-manager.io challenges.acme.cert-manager.io clusterissuers.cert-manager.io issuers.cert-manager.io orders.acme.cert-manager.io; do
  manager_index="$(kubectl get crd "${crd_name}" --show-managed-fields --output json | jq -r '.metadata.managedFields | map(.manager == "cainjector") | index(true)')"
  [ "$manager_index" != "null" ] && kubectl patch crd "${crd_name}" --type=json -p="[{\"op\": \"remove\", \"path\": \"/metadata/managedFields/${manager_index}\"}]"
done
# v1.27

control_plane_upgrade "apply_cert-manager, apply_istio, apply_istio-ingress, apply_istio-private-ingress, apply_logging, apply_metrics, apply_telemetry, apply_argocd"

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
