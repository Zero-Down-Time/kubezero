#!/bin/sh

if [ -n "$DEBUG" ]; then
  set -x
  LOG="--v=5"
fi

# Export vars to ease use in debug_shell etc
export WORKDIR=/tmp/kubezero
export HOSTFS=/host
export CHARTS=/charts
export VERSION=v1.22

export KUBECONFIG="${HOSTFS}/root/.kube/config"

# etcd
export ETCDCTL_API=3
export ETCDCTL_CACERT=${HOSTFS}/etc/kubernetes/pki/etcd/ca.crt
export ETCDCTL_CERT=${HOSTFS}/etc/kubernetes/pki/apiserver-etcd-client.crt
export ETCDCTL_KEY=${HOSTFS}/etc/kubernetes/pki/apiserver-etcd-client.key

mkdir -p ${WORKDIR}

# Generic retry utility
retry() {
  local tries=$1
  local waitfor=$2
  local timeout=$3
  shift 3
  while true; do
    type -tf $1 >/dev/null && { timeout $timeout $@ && return; } || { $@ && return; }
    let tries=$tries-1
    [ $tries -eq 0 ] && return 1
    sleep $waitfor
  done
}


_kubeadm() {
  kubeadm $@ --config /etc/kubernetes/kubeadm.yaml --rootfs ${HOSTFS} $LOG
}


# Render cluster config
render_kubeadm() {
  helm template $CHARTS/kubeadm --output-dir ${WORKDIR} -f ${HOSTFS}/etc/kubernetes/kubezero.yaml

  # Assemble kubeadm config
  cat /dev/null > ${HOSTFS}/etc/kubernetes/kubeadm.yaml
  for f in Cluster Init Join KubeProxy Kubelet; do
    # echo "---" >> /etc/kubernetes/kubeadm.yaml
    cat ${WORKDIR}/kubeadm/templates/${f}Configuration.yaml >> ${HOSTFS}/etc/kubernetes/kubeadm.yaml
  done

  # hack to "uncloack" the json patches after they go processed by helm
  for s in apiserver controller-manager scheduler; do
    yq eval '.json' ${WORKDIR}/kubeadm/templates/patches/kube-${s}1\+json.yaml > /tmp/_tmp.yaml && \
      mv /tmp/_tmp.yaml ${WORKDIR}/kubeadm/templates/patches/kube-${s}1\+json.yaml
  done
}


parse_kubezero() {
  [ -f ${HOSTFS}/etc/kubernetes/kubezero.yaml ] || { echo "Missing /etc/kubernetes/kubezero.yaml!"; return 1; }

  export KUBE_VERSION=$(kubeadm version -o yaml | yq eval .clientVersion.gitVersion -)
  export CLUSTERNAME=$(yq eval '.clusterName' ${HOSTFS}/etc/kubernetes/kubezero.yaml)
  export ETCD_NODENAME=$(yq eval '.etcd.nodeName' ${HOSTFS}/etc/kubernetes/kubezero.yaml)
  export NODENAME=$(yq eval '.nodeName' ${HOSTFS}/etc/kubernetes/kubezero.yaml)

  export AWS_IAM_AUTH=$(yq eval '.api.awsIamAuth.enabled' ${HOSTFS}/etc/kubernetes/kubezero.yaml)
  export AWS_NTH=$(yq eval '.addons.aws-node-termination-handler.enabled' ${HOSTFS}/etc/kubernetes/kubezero.yaml)

  # From here on bail out, allows debug_shell even in error cases
  set -e
}


# Shared steps before calling kubeadm
pre_kubeadm() {
  # update all apiserver addons first
  cp -r ${WORKDIR}/kubeadm/templates/apiserver ${HOSTFS}/etc/kubernetes

  # aws-iam-authenticator enabled ?
  if [ "$AWS_IAM_AUTH" == "true" ]; then

    # Initialize webhook
    if [ ! -f ${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.crt ]; then
      ${HOSTFS}/usr/bin/aws-iam-authenticator init -i ${CLUSTERNAME}
      mv key.pem ${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.key
      mv cert.pem ${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.crt
    fi

    # Patch the aws-iam-authenticator config with the actual cert.pem
    yq eval -Mi ".clusters[0].cluster.certificate-authority-data = \"$(cat ${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.crt| base64 -w0)\"" ${HOSTFS}/etc/kubernetes/apiserver/aws-iam-authenticator.yaml
  fi

  # copy patches to host to make --rootfs of kubeadm work
  cp -r ${WORKDIR}/kubeadm/templates/patches /host/tmp/
}


# Shared steps after calling kubeadm
post_kubeadm() {
  # KubeZero resources
  for f in ${WORKDIR}/kubeadm/templates/resources/*.yaml; do
    kubectl apply -f $f $LOG
  done

  # Patch coreDNS addon, ideally we prevent kubeadm to reset coreDNS to its defaults
  kubectl patch deployment coredns -n kube-system --patch-file ${WORKDIR}/kubeadm/templates/patches/coredns0.yaml $LOG

  rm -rf /host/tmp/patches
}


# First parse kubezero.yaml
parse_kubezero

if [ "$1" == 'upgrade' ]; then
  ### PRE 1.22 specific
  #####################

  kubectl delete runtimeclass crio

  #####################

  render_kubeadm

  pre_kubeadm

  # Upgrade
  _kubeadm upgrade apply -y

  post_kubeadm

  # If we have a re-cert kubectl config install for root
  if [ -f ${HOSTFS}/etc/kubernetes/admin.conf ]; then
    cp ${HOSTFS}/etc/kubernetes/admin.conf ${HOSTFS}/root/.kube/config
  fi

  ### POST 1.22 specific

  # Remove all remaining kiam
  helm repo add uswitch https://uswitch.github.io/kiam-helm-charts/charts/
  helm repo update
  helm template uswitch/kiam --name-template kiam --set server.deployment.enabled=true --set server.prometheus.servicemonitor.enabled=true --set agent.prometheus.servicemonitor.enabled=true | kubectl delete --namespace kube-system -f - || true

  ######################
  # network
  yq eval '.network // ""' ${HOSTFS}/etc/kubernetes/kubezero.yaml > _values.yaml
  helm template $CHARTS/kubezero-network --namespace kube-system --include-crds --name-template network \
    -f _values.yaml --kube-version $KUBE_VERSION | kubectl apply --namespace kube-system -f - $LOG

  # addons
  yq eval '.addons // ""' ${HOSTFS}/etc/kubernetes/kubezero.yaml > _values.yaml
  helm template $CHARTS/kubezero-addons --namespace kube-system --include-crds --name-template addons \
    -f _values.yaml --kube-version $KUBE_VERSION | kubectl apply --namespace kube-system -f - $LOG

  ######################

  # Could be removed with 1.23 as we now have persistent etcd
  # Execute cluster backup to allow new controllers to join
  kubectl create job backup-cluster-now --from=cronjob/kubezero-backup -n kube-system
  # That might take a while as the backup pod needs the CNIs to come online etc.
  retry 10 30 40 kubectl wait --for=condition=complete job/backup-cluster-now -n kube-system && kubectl delete job backup-cluster-now -n kube-system

  # Cleanup after kubeadm on the host
  rm -rf ${HOSTFS}/etc/kubernetes/tmp

  echo "Successfully upgraded cluster."

  # TODO
  # Send Notification currently done via CloudBender -> SNS -> Slack
  # Better deploy https://github.com/opsgenie/kubernetes-event-exporter and set proper routes and labels on this Job

  # Removed:
  # - update oidc do we need that ?

elif [[ "$1" == 'node-upgrade' ]]; then
  echo "Starting node upgrade ..."

  echo "All done."

elif [[ "$1" =~ "^(bootstrap|restore|join)$" ]]; then

  render_kubeadm

  # Esnure clean slate if bootstrap, restore PKI otherwise
  if [[ "$1" =~ "^(bootstrap)$" ]]; then
    rm -rf ${HOSTFS}/var/lib/etcd/member

  else
    # Todo: 1.23
    # Workaround for 1.22 as the final backup is still tagged with the previous verion from the cronjob
    #retry 10 60 30 restic restore latest --no-lock -t / --tag $VERSION
    retry 10 60 30 restic restore latest --no-lock -t /

    # Make last etcd snapshot available
    cp ${WORKDIR}/etcd_snapshot ${HOSTFS}/etc/kubernetes

    # Put PKI in place
    cp -r ${WORKDIR}/pki ${HOSTFS}/etc/kubernetes

    # Always use kubeadm kubectl config to never run into chicken egg with custom auth hooks
    cp ${WORKDIR}/admin.conf ${HOSTFS}/root/.kube/config

    # etcd needs to resync during join
    if [[ "$1" =~ "^(restore)$" ]]; then
      # Only restore etcd data set if none exists already
      if [ ! -d ${HOSTFS}/var/lib/etcd/member ]; then
        etcdctl snapshot restore ${HOSTFS}/etc/kubernetes/etcd_snapshot \
          --name $ETCD_NODENAME \
          --data-dir="${HOSTFS}/var/lib/etcd" \
          --initial-cluster-token etcd-${CLUSTERNAME} \
          --initial-advertise-peer-urls https://${ETCD_NODENAME}:2380 \
          --initial-cluster $ETCD_NODENAME=https://${ETCD_NODENAME}:2380
      fi
    fi
  fi

  # Delete old node certs in case they are around
  rm -f ${HOSTFS}/etc/kubernetes/pki/etcd/peer.* ${HOSTFS}/etc/kubernetes/pki/etcd/server.* ${HOSTFS}/etc/kubernetes/pki/etcd/healthcheck-client.* \
    ${HOSTFS}/etc/kubernetes/pki/apiserver* ${HOSTFS}/etc/kubernetes/pki/front-proxy-client.*

  # Issue all certs first, needed for eg. aws-iam-authenticator setup
  _kubeadm init phase certs all

  pre_kubeadm

  # Pull all images
  _kubeadm config images pull

  _kubeadm init phase preflight
  _kubeadm init phase kubeconfig all

  if [[ "$1" =~ "^(join)$" ]]; then
    # get current running etcd pods for etcdctl commands
    while true; do
      etcd_endpoints=$(kubectl get pods -n kube-system -l component=etcd -o yaml | \
        yq eval '.items[].metadata.annotations."kubeadm.kubernetes.io/etcd.advertise-client-urls"' - | tr '\n' ',' | sed -e 's/,$//')
      [[ $etcd_endpoints =~ ^https:// ]] && break
      sleep 3
    done

    # if we are NOT member already, flush etcd to be able to join
    MY_ID=$(etcdctl member list --endpoints=$etcd_endpoints | grep $ETCD_NODENAME | awk '{print $1}' | sed -e 's/,$//')

    # Failsafe / etcd on ephmeral: we were a member but our dataset is missing
    # -> remove former self so we can re-join
    if [ -n "$MY_ID" -a ! -d ${HOSTFS}/var/lib/etcd/member ]; then
      # Remove former self first
      [ -n "$MY_ID" ] && retry 12 5 5 etcdctl member remove $MY_ID --endpoints=$etcd_endpoints
      MY_ID=""
    fi


    if [ -z "$MY_ID" ]; then
      # flush etcd data directory from restore
      rm -rf ${HOSTFS}/var/lib/etcd/member

      # Announce new etcd member and capture ETCD_INITIAL_CLUSTER, retry needed in case another node joining causes temp quorum loss
      ETCD_ENVS=$(retry 12 5 5 etcdctl member add $ETCD_NODENAME --peer-urls="https://${ETCD_NODENAME}:2380" --endpoints=$etcd_endpoints)
      export $(echo "$ETCD_ENVS" | grep ETCD_INITIAL_CLUSTER= | sed -e 's/"//g')
    else
      # build initial_cluster string from running cluster
      _cluster=$(etcdctl member list --endpoints=$etcd_endpoints -w json | jq -r '.members[] | "\(.name)=\(.peerURLs[]),"')
      export ETCD_INITIAL_CLUSTER=$(echo ${_cluster%%,} | sed -e 's/ //g')
    fi

    # Patch kubezero.yaml and re-render to get etcd manifest patched
    yq eval -i '.etcd.state = "existing"
      | .etcd.initialCluster = strenv(ETCD_INITIAL_CLUSTER)
      ' ${HOSTFS}/etc/kubernetes/kubezero.yaml
    render_kubeadm

    # Delete any former self in case forseti did not delete yet
    kubectl delete node ${NODENAME} --wait=true || true
  fi

  # Generate our custom etcd yaml
  _kubeadm init phase etcd local
  _kubeadm init phase control-plane all

  _kubeadm init phase kubelet-start

  cp ${HOSTFS}/etc/kubernetes/admin.conf ${HOSTFS}/root/.kube/config

  # Wait for api to be online
  echo "Waiting for Kubernetes API to be online ..."
  retry 0 5 30 kubectl cluster-info --request-timeout 3 >/dev/null

  if [[ ! "$1" =~ "^(join)$" ]]; then
    _kubeadm init phase upload-config all
    _kubeadm init phase upload-certs --skip-certificate-key-print

    # This sets up the ClusterRoleBindings to allow bootstrap nodes to create CSRs etc.
    _kubeadm init phase bootstrap-token --skip-token-print
  fi

  _kubeadm init phase mark-control-plane
  _kubeadm init phase kubelet-finalize all

  if [[ ! "$1" =~ "^(join)$" ]]; then
    _kubeadm init phase addon all
  fi

  # Ensure aws-iam-authenticator secret is in place
  if [ "$AWS_IAM_AUTH" == "true" ]; then
    kubectl get secrets -n kube-system aws-iam-certs || \
    kubectl create secret generic aws-iam-certs -n kube-system \
      --from-file=key.pem=${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.key \
      --from-file=cert.pem=${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.crt

    # Store aws-iam-auth admin on SSM
    yq eval -M ".clusters[0].cluster.certificate-authority-data = \"$(cat ${HOSTFS}/etc/kubernetes/pki/ca.crt | base64 -w0)\"" ${WORKDIR}/kubeadm/templates/admin-aws-iam.yaml > ${HOSTFS}/etc/kubernetes/admin-aws-iam.yaml
  fi

  # install / update network and addons
  if [[ "$1" =~ "^(bootstrap|join)$" ]]; then
    # network
    yq eval '.network // ""' ${HOSTFS}/etc/kubernetes/kubezero.yaml > _values.yaml
    helm template $CHARTS/kubezero-network --namespace kube-system --include-crds --name-template network \
      -f _values.yaml --kube-version $KUBE_VERSION | kubectl apply --namespace kube-system -f - $LOG

    # addons
    yq eval '.addons // ""' ${HOSTFS}/etc/kubernetes/kubezero.yaml > _values.yaml
    helm template $CHARTS/kubezero-addons --namespace kube-system --include-crds --name-template addons \
      -f _values.yaml --kube-version $KUBE_VERSION | kubectl apply --namespace kube-system -f - $LOG
  fi

  post_kubeadm

  echo "${1} cluster $CLUSTERNAME successfull."


# Since 1.21 we only need to backup etcd + /etc/kubernetes/pki !
elif [ "$1" == 'backup' ]; then
  restic snapshots || restic init || exit 1

  etcdctl --endpoints=https://${ETCD_NODENAME}:2379 snapshot save ${WORKDIR}/etcd_snapshot

  # pki & cluster-admin access
  cp -r ${HOSTFS}/etc/kubernetes/pki ${WORKDIR}
  cp -r ${HOSTFS}/etc/kubernetes/admin.conf ${WORKDIR}

  # Backup via restic
  restic snapshots || restic init
  restic backup ${WORKDIR} -H $CLUSTERNAME --tag $VERSION

  echo "Backup complete."

  # Remove backups from previous versions
  restic forget --keep-tag $VERSION --prune

  # Regular retention
  restic forget --keep-hourly 24 --keep-daily ${RESTIC_RETENTION:-7} --prune

  # Defrag etcd backend
  etcdctl --endpoints=https://${ETCD_NODENAME}:2379 defrag


elif [ "$1" == 'debug_shell' ]; then
  echo "Entering debug shell"

  printf "For manual etcdctl commands use:\n  # export ETCDCTL_ENDPOINTS=$ETCD_NODENAME:2379\n"

  /bin/sh

else
  echo "Unknown command!"
  exit 1
fi
