#!/bin/bash -e

#VERSION="latest"
VERSION="v1.25"
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
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
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
  - key: node-role.kubernetes.io/master
    operator: Exists
    effect: NoSchedule
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

# Cleanup
# Remove calico CRDs
kubectl delete -f https://git.zero-downtime.net/ZeroDownTime/kubezero/raw/tag/v1.23.11/charts/kubezero-network/charts/calico/crds/crds.yaml 2>/dev/null || true

# delete old kubelet configs
for cm in $(kubectl get cm -n kube-system --no-headers |  awk '{if ($1 ~ "kubelet-config-1*") print $1}'); do kubectl delete cm $cm -n kube-system; done
for rb in $(kubectl get rolebindings -n kube-system --no-headers |  awk '{if ($1 ~ "kubelet-config-1*") print $1}'); do kubectl delete rolebindings $rb -n kube-system; done

control_plane_upgrade kubeadm_upgrade

echo "Adjust kubezero values as needed:"
# shellcheck disable=SC2015
argo_used && kubectl edit app kubezero -n argocd || kubectl edit cm kubezero-values -n kube-system

control_plane_upgrade "apply_network, apply_addons, apply_storage"

echo "Checking that all pods in kube-system are running ..."
waitSystemPodsRunning

echo "Applying remaining KubeZero modules..."

control_plane_upgrade "apply_cert-manager, apply_istio, apply_istio-ingress, apply_istio-private-ingress, apply_logging, apply_metrics, apply_argocd"

# Final step is to commit the new argocd kubezero app
kubectl get app kubezero -n argocd -o yaml | yq 'del(.status) | del(.metadata) | del(.operation) | .metadata.name="kubezero" | .metadata.namespace="argocd"' | yq 'sort_keys(..) | .spec.source.helm.values |= (from_yaml | to_yaml)' > $ARGO_APP

echo "Please commit $ARGO_APP as the updated kubezero/application.yaml for your cluster."
echo "Then head over to ArgoCD for this cluster and sync all KubeZero modules to apply remaining upgrades."

echo "<Return> to continue and re-enable ArgoCD:"
read -r

argo_used && enable_argo
