#!/bin/bash -e

echo "Deploy all node upgrade daemonSet(busybox)"
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
metadata:
  name: kubezero-admin-script
  namespace: kube-system
kind: ConfigMap
data:
  script: |-
    #!/bin/bash
    #set -x

    POD_IDS=($(crictl pods -q))
    POD_UIDS=()

    for POD_ID in ${POD_IDS[@]}; do
      JSONDUMP="`crictl inspectp ${POD_ID}`"
      POD_NAME="`echo ${JSONDUMP} | jq -r '.status.metadata.name'`"
      POD_UID="`echo ${JSONDUMP} | jq -r '.info.runtimeSpec.annotations."io.kubernetes.pod.uid"'`"
      POD_UIDS+=($POD_UID)
    done

    # echo ${POD_UIDS[*]}

    CGROUPS=($(find /sys/fs/cgroup/pids/kubepods/*/pod* -type d -depth || true))
    CGROUPS+=($(find /sys/fs/cgroup/kubepods/*/pod* -type d -depth || true))

    DELETED=0
    for cg in ${CGROUPS[*]}; do
      valid=0
      for uid in ${POD_UIDS[*]}; do
        echo $cg | grep -q $uid && { valid=1; break; }
      done

      if [ $valid -eq 0 ]; then
        rmdir $cg
        ((DELETED=DELETED+1))
      fi
    done

    echo "Removed $DELETED left over cgroup folders."
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: kubezero-run-all-nodes
  namespace: kube-system
  labels:
    app: kubezero-admin-all-nodes
spec:
  selector:
    matchLabels:
      name: kubezero-admin-all-nodes
  template:
    metadata:
      labels:
        name: kubezero-admin-all-nodes
    spec:
      hostNetwork: true
      hostIPC: true
      hostPID: true
      tolerations:
      - operator: Exists
      initContainers:
      - name: kubezero-run-all-nodes
        image: busybox
        command: ["/bin/sh"]
        args: ["-c", "cp /tmp/admin-script.sh /host/tmp/admin-script.sh && chmod +x /host/tmp/admin-script.sh && chroot /host /tmp/admin-script.sh"]
        volumeMounts:
        - name: host
          mountPath: /host
        - name: hostproc
          mountPath: /hostproc
        - name: admin-script
          mountPath: "/tmp/admin-script.sh"
          subPath: script
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
      - name: admin-script
        configMap:
          name: kubezero-admin-script
EOF

kubectl rollout status daemonset -n kube-system kubezero-run-all-nodes --timeout 300s

kubectl logs --selector name=kubezero-admin-all-nodes -c kubezero-run-all-nodes -n kube-system

kubectl delete ds kubezero-run-all-nodes -n kube-system
kubectl delete cm kubezero-admin-script -n kube-system
