#!/bin/sh
set -e

if [ -n "$DEBUG" ]; then
  set -x
  LOG="--v=5"
fi

# Export vars to ease use in debug_shell etc
export WORKDIR=/tmp/kubezero
export HOSTFS=/host
export VERSION=v1.21
export NETWORK_VERSION=0.1.7
export ADDONS_VERSION=0.4.2

export KUBECONFIG="${HOSTFS}/root/.kube/config"

# etcd
export ETCDCTL_API=3
export ETCDCTL_CACERT=${HOSTFS}/etc/kubernetes/pki/etcd/ca.crt
export ETCDCTL_CERT=${HOSTFS}/etc/kubernetes/pki/apiserver-etcd-client.crt
export ETCDCTL_KEY=${HOSTFS}/etc/kubernetes/pki/apiserver-etcd-client.key

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
  helm template /opt/kubeadm --output-dir ${WORKDIR} -f ${HOSTFS}/etc/kubernetes/kubezero.yaml

  # Assemble kubeadm config
  cat /dev/null > ${HOSTFS}/etc/kubernetes/kubeadm.yaml
  for f in Cluster Init KubeProxy Kubelet; do
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
  [ -f ${HOSTFS}/etc/kubernetes/kubezero.yaml ] || { echo "Missing /etc/kubernetes/kubezero.yaml!"; exit 1; }

  export KUBE_VERSION=$(kubeadm version -o yaml | yq eval .clientVersion.gitVersion -)
  export CLUSTERNAME=$(yq eval '.clusterName' ${HOSTFS}/etc/kubernetes/kubezero.yaml)
  export ETCD_NODENAME=$(yq eval '.etcd.nodeName' ${HOSTFS}/etc/kubernetes/kubezero.yaml)

  export AWS_IAM_AUTH=$(yq eval '.api.awsIamAuth.enabled' ${HOSTFS}/etc/kubernetes/kubezero.yaml)
  export AWS_NTH=$(yq eval '.addons.aws-node-termination-handler.enabled' ${HOSTFS}/etc/kubernetes/kubezero.yaml)
}


# Shared steps before calling kubeadm
pre_kubeadm() {
  # update all apiserver addons first
  cp -r ${WORKDIR}/kubeadm/templates/apiserver ${HOSTFS}/etc/kubernetes

  # aws-iam-authenticator enabled ?
  if [ "$AWS_IAM_AUTH" == "true" ]; then

    # Initialize webhook
    if [ ! -f ${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.crt ]; then
      aws-iam-authenticator init -i ${CLUSTERNAME}
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
  ### PRE 1.21 specific
  #####################

  # Migrate aws-iam-authenticator from file certs to secret
  if [ "$AWS_IAM_AUTH" == "true" ]; then
    kubectl get secrets -n kube-system aws-iam-certs || \
    kubectl create secret generic aws-iam-certs -n kube-system \
      --from-file=key.pem=${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.key \
      --from-file=cert.pem=${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.crt
  fi

  #####################

  render_kubeadm

  pre_kubeadm

  # Upgrade
  _kubeadm upgrade apply -y --experimental-patches /tmp/patches

  post_kubeadm

  # If we have a re-cert kubectl config install for root
  if [ -f ${HOSTFS}/etc/kubernetes/admin.conf ]; then
    cp ${HOSTFS}/etc/kubernetes/admin.conf ${HOSTFS}/root/.kube/config
  fi

  ### POST 1.21 specific
  # Delete any previous aws-node-term config as they changed the labels ;-(
  kubectl delete deployment aws-node-termination-handler -n kube-system || true
  
  ######################
  helm repo add kubezero https://cdn.zero-downtime.net/charts/

  # network
  yq eval '.network // ""' ${HOSTFS}/etc/kubernetes/kubezero.yaml > _values.yaml
  helm template kubezero/kubezero-network --version $NETWORK_VERSION --namespace kube-system --include-crds --name-template network \
    -f _values.yaml --kube-version $KUBE_VERSION | kubectl apply --namespace kube-system -f - $LOG

  # addons
  yq eval '.addons // ""' ${HOSTFS}/etc/kubernetes/kubezero.yaml > _values.yaml
  helm template kubezero/kubezero-addons --version $ADDONS_VERSION --namespace kube-system --include-crds --name-template addons \
    -f _values.yaml --kube-version $KUBE_VERSION | kubectl apply --namespace kube-system -f - $LOG

  ######################

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

  echo "Migrating kubezero.yaml"
  yq -i eval '.api.etcdServers = .api.allEtcdEndpoints | .network.multus.enabled = "true"' ${HOSTFS}/etc/kubernetes/kubezero.yaml

  # remove old aws-node-termination-handler config, first new controller will do the right thing
  yq -i eval 'del(.addons.aws-node-termination-handler)' ${HOSTFS}/etc/kubernetes/kubezero.yaml

  # AWS
  if [ -f ${HOSTFS}/etc/cloudbender/clusterBackup.passphrase ]; then
    if [ -f ${HOSTFS}/usr/local/sbin/backup_control_plane.sh ]; then
      mv ${HOSTFS}/usr/local/sbin/backup_control_plane.sh ${HOSTFS}/usr/local/sbin/backup_control_plane.disabled
      echo "Disabled old cluster backup OS cronjob"
    fi

    # enable backup and awsIamAuth & multus
    yq -i eval '
        .api.awsIamAuth.enabled = "true" | .api.awsIamAuth.workerNodeRole = .workerNodeRole | .api.awsIamAuth.kubeAdminRole = .kubeAdminRole
      | .api.serviceAccountIssuer = .serviceAccountIssuer | .api.apiAudiences = "istio-ca,sts.amazonaws.com"
      ' ${HOSTFS}/etc/kubernetes/kubezero.yaml

    export restic_repo=$(grep "export RESTIC_REPOSITORY" ${HOSTFS}/usr/local/sbin/backup_control_plane.disabled | sed -e 's/.*=//' | sed -e 's/"//g')
    export restic_pw="$(cat ${HOSTFS}/etc/cloudbender/clusterBackup.passphrase)"
    export REGION=$(kubectl get node $NODE_NAME -o yaml | yq eval '.metadata.labels."topology.kubernetes.io/region"' -)

    if [ -n "$restic_repo" ]; then
      yq -i eval '
        .addons.clusterBackup.enabled = "true" | .addons.clusterBackup.repository = strenv(restic_repo) | .addons.clusterBackup.password = strenv(restic_pw)
      | .addons.clusterBackup.image.tag = strenv(KUBE_VERSION)
      | .addons.clusterBackup.extraEnv[0].name = "AWS_DEFAULT_REGION" | .addons.clusterBackup.extraEnv[0].value = strenv(REGION)
      ' ${HOSTFS}/etc/kubernetes/kubezero.yaml
    fi
  fi

  echo "All done."

elif [[ "$1" =~ "^(bootstrap|recover|join)$" ]]; then

  render_kubeadm

  if [[ "$1" =~ "^(bootstrap)$" ]]; then
    # Create all certs during bootstrap
    _kubeadm init phase certs all

  else
    # Recert certificates for THIS node
    rm -f ${HOSTFS}/etc/kubernetes/pki/etcd/peer.* ${HOSTFS}/etc/kubernetes/pki/etcd/server.* ${HOSTFS}/etc/kubernetes/pki/apiserver.*
    _kubeadm init phase certs etcd-server
    _kubeadm init phase certs etcd-peer
    _kubeadm init phase certs apiserver
  fi

  pre_kubeadm

  if [[ "$1" =~ "^(join)$" ]]; then

    _kubeadm init phase preflight
    _kubeadm init phase kubeconfig all
    _kubeadm init phase kubelet-start

    # flush etcd data directory from restore
    rm -rf ${HOSTFS}/var/lib/etcd/member

    # get current running etcd pods for etcdctl commands
    while true; do
      etcd_endpoints=$(kubectl get pods -n kube-system -l component=etcd -o yaml | \
        yq eval '.items[].metadata.annotations."kubeadm.kubernetes.io/etcd.advertise-client-urls"' - | tr '\n' ',' | sed -e 's/,$//')
      [[ $etcd_endpoints =~ ^https:// ]] && break
      sleep 3
    done

    # is our $ETCD_NODENAME already in the etcd cluster ?
    # Remove former self first
    MY_ID=$(etcdctl member list --endpoints=$etcd_endpoints | grep $ETCD_NODENAME | awk '{print $1}' | sed -e 's/,$//')
    [ -n "$MY_ID" ] && retry 12 5 5 etcdctl member remove $MY_ID --endpoints=$etcd_endpoints

    # Announce new etcd member and capture ETCD_INITIAL_CLUSTER, retry needed in case another node joining causes temp quorum loss
    ETCD_ENVS=$(retry 12 5 5 etcdctl member add $ETCD_NODENAME --peer-urls="https://${ETCD_NODENAME}:2380" --endpoints=$etcd_endpoints)
    export $(echo "$ETCD_ENVS" | grep ETCD_INITIAL_CLUSTER= | sed -e 's/"//g')

    # Patch kubezero.yaml and re-render to get etcd manifest patched
    yq eval -i '.etcd.state = "existing"
      | .etcd.initialCluster = strenv(ETCD_INITIAL_CLUSTER)
      ' ${HOSTFS}/etc/kubernetes/kubezero.yaml
    render_kubeadm

    # Generate our advanced etcd yaml
    _kubeadm init phase etcd local --experimental-patches /tmp/patches

    _kubeadm init phase control-plane all --experimental-patches /tmp/patches
    _kubeadm init phase mark-control-plane
    _kubeadm init phase kubelet-finalize all

  else
    _kubeadm init --experimental-patches /tmp/patches --skip-token-print
  fi

  cp ${HOSTFS}/etc/kubernetes/admin.conf ${HOSTFS}/root/.kube/config

  # Wait for api to be online
  retry 0 10 30 kubectl cluster-info --request-timeout 3

  # Ensure aws-iam-authenticator secret is in place
  if [ "$AWS_IAM_AUTH" == "true" ]; then
    kubectl get secrets -n kube-system aws-iam-certs || \
    kubectl create secret generic aws-iam-certs -n kube-system \
      --from-file=key.pem=${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.key \
      --from-file=cert.pem=${HOSTFS}/etc/kubernetes/pki/aws-iam-authenticator.crt

    # Store aws-iam-auth admin on SSM
    yq eval -M ".clusters[0].cluster.certificate-authority-data = \"$(cat ${HOSTFS}/etc/kubernetes/pki/ca.crt | base64 -w0)\"" ${WORKDIR}/kubeadm/templates/admin-aws-iam.yaml > ${HOSTFS}/etc/kubernetes/admin-aws-iam.yaml
  fi

  # Install some basics on bootstrap and join for 1.21 to get new modules in place
  if [[ "$1" =~ "^(bootstrap|join|recover)$" ]]; then
    helm repo add kubezero https://cdn.zero-downtime.net/charts/

    # network
    yq eval '.network // ""' ${HOSTFS}/etc/kubernetes/kubezero.yaml > _values.yaml
    helm template kubezero/kubezero-network --version $NETWORK_VERSION --namespace kube-system --include-crds --name-template network \
      -f _values.yaml --kube-version $KUBE_VERSION | kubectl apply --namespace kube-system -f - $LOG

    # addons
    yq eval '.addons // ""' ${HOSTFS}/etc/kubernetes/kubezero.yaml > _values.yaml
    helm template kubezero/kubezero-addons --version $ADDONS_VERSION --namespace kube-system --include-crds --name-template addons \
      -f _values.yaml --kube-version $KUBE_VERSION | kubectl apply --namespace kube-system -f - $LOG
  fi

  post_kubeadm

  echo "${1} cluster $CLUSTERNAME successfull."


# Since 1.21 we only need to backup etcd + /etc/kubernetes/pki !
elif [ "$1" == 'backup' ]; then
  mkdir -p ${WORKDIR}

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


elif [ "$1" == 'restore' ]; then
  mkdir -p ${WORKDIR}

  restic restore latest --no-lock -t / --tag $VERSION

  # Make last etcd snapshot available
  cp ${WORKDIR}/etcd_snapshot ${HOSTFS}/etc/kubernetes

  # Put PKI in place
  cp -r ${WORKDIR}/pki ${HOSTFS}/etc/kubernetes

  # Always use kubeadm kubectl config to never run into chicken egg with custom auth hooks
  cp ${WORKDIR}/admin.conf ${HOSTFS}/root/.kube/config

  etcdctl snapshot restore ${HOSTFS}/etc/kubernetes/etcd_snapshot \
    --name $ETCD_NODENAME \
    --data-dir="${HOSTFS}/var/lib/etcd" \
    --initial-cluster-token etcd-${CLUSTERNAME} \
    --initial-advertise-peer-urls https://${ETCD_NODENAME}:2380 \
    --initial-cluster $ETCD_NODENAME=https://${ETCD_NODENAME}:2380

  echo "Backup restored."


elif [ "$1" == 'debug_shell' ]; then
  echo "Entering debug shell"
  /bin/sh

else
  echo "Unknown command!"
  exit 1
fi
