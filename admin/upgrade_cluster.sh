#!/bin/bash -e

VERSION="v1.23"
#VERSION="latest"
ARGO_APP=${1:-/tmp/new-kubezero-argoapp.yaml}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/libhelm.sh

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

  echo "Deploy cluster admin task: $TASK"
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

all_nodes_upgrade "nsenter -m/hostproc/1/ns/mnt mount --make-shared /sys/fs/cgroup; nsenter -m/hostproc/1/ns/mnt mount --make-shared /sys; nsenter -r/host /usr/bin/podman image prune -a -f;"

control_plane_upgrade kubeadm_upgrade

echo "Adjust kubezero values as needed: (eg. set cilium cluster id and ensure no IP space overlap !!):"
argo_used && kubectl edit app kubezero -n argocd || kubectl edit cm kubezero-values -n kube-system

# Remove multus DS due to label changes, if this fails:
# kubezero-network $ helm template . --set multus.enabled=true | kubectl apply -f -
kubectl delete ds kube-multus-ds -n kube-system || true

# Required due to chart upgrade to 4.X part of prometheus-stack 40.X
kubectl delete daemonset metrics-prometheus-node-exporter -n monitoring || true

# AWS EBS CSI driver change their fsGroupPolicy
kubectl delete CSIDriver ebs.csi.aws.com || true

# Delete external-dns deployment as upstream changed strategy to 'recreate'
kubectl delete deployment addons-external-dns -n kube-system || true

control_plane_upgrade "apply_network, apply_addons, apply_storage"

kubectl rollout restart daemonset/calico-node -n kube-system
kubectl rollout restart daemonset/cilium -n kube-system
kubectl rollout restart daemonset/kube-multus-ds -n kube-system

echo "Checking that all pods in kube-system are running ..."
waitSystemPodsRunning

echo "Applying remaining KubeZero modules..."

# Delete outdated cert-manager CRDs, otherwise serverside apply will fail
for c in certificaterequests.cert-manager.io certificates.cert-manager.io challenges.acme.cert-manager.io clusterissuers.cert-manager.io issuers.cert-manager.io orders.acme.cert-manager.io; do
  kubectl delete crd $c
done

control_plane_upgrade "apply_cert-manager, apply_istio, apply_istio-ingress, apply_istio-private-ingress, apply_logging, apply_metrics, apply_argocd"

# delete legace ArgCD controller which is now a statefulSet
kubectl delete deployment argocd-application-controller -n argocd || true

# Final step is to commit the new argocd kubezero app
kubectl get app kubezero -n argocd -o yaml | yq 'del(.status) | del(.metadata) | del(.operation) | .metadata.name="kubezero" | .metadata.namespace="argocd"' | yq 'sort_keys(..) | .spec.source.helm.values |= (from_yaml | to_yaml)' > $ARGO_APP

echo "Please commit $ARGO_APP as the updated kubezero/application.yaml for your cluster."
echo "Then head over to ArgoCD for this cluster and sync all KubeZero modules to apply remaining upgrades."

echo "<Return> to continue and re-enable ArgoCD:"
read

argo_used && enable_argo
