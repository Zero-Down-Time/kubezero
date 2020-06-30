#!/bin/bash
set -e

DEPLOY_DIR=$( dirname $( realpath $0 ))

# Waits for max 300s and retries
function wait_for() {
  local TRIES=0
  while true; do
    $@ && break
    [ $TRIES -eq 100 ] && return 1
    let TRIES=$TRIES+1
		sleep 3
  done
}

helm repo add kubezero https://zero-down-time.github.io/kubezero
helm repo update

# Determine if we bootstrap or update
helm list -n argocd -f kubezero -q | grep -q kubezero && rc=$? || rc=$?
if [ $rc -eq 0 ]; then
  helm template $DEPLOY_DIR -f values.yaml -f kubezero.yaml > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
else
  # During bootstrap we first generate a minimal values.yaml to prevent various deadlocks

  # Generate ArgoCD password if not in values.yaml yet and add it
  grep -q argocdServerAdminPassword values.yaml && rc=$? || rc=$?
  if [ $rc -ne 0 ]; then
    _argo_date="$(date -u --iso-8601=seconds)"
    _argo_passwd="$($DEPLOY_DIR/argocd_password.py)"

    cat <<EOF >> values.yaml
  configs:
    secret:
      # ArgoCD password: ${_argo_passwd%%:*} Please move to secure location !
      argocdServerAdminPassword: "${_argo_passwd##*:}"
      argocdServerAdminPasswordMtime: "$_argo_date"
EOF
  fi

  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml --set bootstrap=true > generated-values.yaml

  # Deploy initial argo-cd
  helm install -n argocd kubezero kubezero/kubezero-argo-cd --create-namespace -f generated-values.yaml

  # Wait for argocd-server to be running
  kubectl rollout status deployment -n argocd kubezero-argocd-server

  # Now wait for cert-manager to be bootstrapped
  echo "Waiting for cert-manager to be deployed..."
  wait_for kubectl get deployment -n cert-manager cert-manager-webhook 2>/dev/null 1>&2
  kubectl rollout status deployment -n cert-manager cert-manager-webhook

  # Now lets get kiam and cert-manager to work as they depend on each other, keep advanced options still disabled though
  # - istio, prometheus
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml --set istio.enabled=false --set prometheus.enabled=false > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml

	exit 0
  # Todo: Now we need to wait till all is synced and healthy ... argocd cli or kubectl ?
  # Wait for aws-ebs or kiam to be all ready, or all pods running ?

  # Todo: 
  # - integrate Istio
  # - integrate Prometheus-Grafana

  # Finally we could enable the actual config and deploy all
  helm template $DEPLOY_DIR -f values.yaml -f cloudbender.yaml > generated-values.yaml
  helm upgrade -n argocd kubezero kubezero/kubezero-argo-cd -f generated-values.yaml
fi
