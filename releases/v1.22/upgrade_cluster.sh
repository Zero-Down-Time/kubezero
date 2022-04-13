#!/bin/bash -e

VERSION="v1.22.8"

[ -n "$DEBUG" ] && DEBUG=1

# unset any AWS_DEFAULT_PROFILE as it will break aws-iam-auth
unset AWS_DEFAULT_PROFILE

echo "Deploying cluster upgrade job ..."

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: kubezero-upgrade-${VERSION//.}
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
    args:
    - upgrade
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

kubectl wait pod kubezero-upgrade-${VERSION//.} -n kube-system --timeout 120s --for=condition=initialized 2>/dev/null
while true; do
  kubectl logs kubezero-upgrade-${VERSION//.} -n kube-system -f 2>/dev/null && break
  sleep 3
done
kubectl delete pod kubezero-upgrade-${VERSION//.} -n kube-system
