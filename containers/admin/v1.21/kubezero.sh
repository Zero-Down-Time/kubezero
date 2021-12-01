#!/bin/sh
set -e

WORKDIR=/tmp/kubezero
HOSTFS=/host

export KUBECONFIG="${HOSTFS}/root/.kube/config"

if [ -n "$DEBUG" ]; then
  set -x
  LOG="--v=5"
fi

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


# Render cluster config
render_kubeadm() {
  helm template /opt/kubeadm --output-dir ${WORKDIR} -f ${HOSTFS}/etc/kubernetes/kubezero.yaml

  # Assemble kubeadm config
  cat /dev/null > ${HOSTFS}/etc/kubernetes/kubeadm-etcd.yaml
  for f in Cluster Init KubeProxy Kubelet; do
    # echo "---" >> /etc/kubernetes/kubeadm-etcd.yaml
    cat ${WORKDIR}/kubeadm/templates/${f}Configuration.yaml >> ${HOSTFS}/etc/kubernetes/kubeadm-etcd.yaml
  done

  # Remove etcd custom cert entries from final kubeadm config
  yq eval 'del(.etcd.local.serverCertSANs) | del(.etcd.local.peerCertSANs)' \
    ${HOSTFS}/etc/kubernetes/kubeadm-etcd.yaml > ${HOSTFS}/etc/kubernetes/kubeadm.yaml

  # Copy JoinConfig
  cp ${WORKDIR}/kubeadm/templates/JoinConfiguration.yaml ${HOSTFS}/etc/kubernetes

  # hack to "uncloack" the json patches after they go processed by helm
  for s in apiserver controller-manager scheduler; do
    yq eval '.json' ${WORKDIR}/kubeadm/templates/patches/kube-${s}1\+json.yaml > /tmp/_tmp.yaml && \
      mv /tmp/_tmp.yaml ${WORKDIR}/kubeadm/templates/patches/kube-${s}1\+json.yaml
  done
}


parse_kubezero() {
  [ -f ${HOSTFS}/etc/kubernetes/kubezero.yaml ] || { echo "Missing /etc/kubernetes/kubezero.yaml!"; exit 1; }

  KUBE_VERSION=$(kubeadm version -o yaml | yq eval .clientVersion.gitVersion -)
  CLUSTERNAME=$(yq eval '.clusterName' ${HOSTFS}/etc/kubernetes/kubezero.yaml)
  NODENAME=$(yq eval '.nodeName' ${HOSTFS}/etc/kubernetes/kubezero.yaml)

  AWS_IAM_AUTH=$(yq eval '.api.awsIamAuth.enabled' ${HOSTFS}/etc/kubernetes/kubezero.yaml)
  AWS_NTH=$(yq eval '.addons.aws-node-termination-handler.enabled' ${HOSTFS}/etc/kubernetes/kubezero.yaml)
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
  kubeadm upgrade apply --config /etc/kubernetes/kubeadm.yaml --rootfs ${HOSTFS} \
    --experimental-patches /tmp/patches $LOG -y

  post_kubeadm

  # If we have a re-cert kubectl config install for root
  if [ -f ${HOSTFS}/etc/kubernetes/admin.conf ]; then
    cp ${HOSTFS}/etc/kubernetes/admin.conf ${HOSTFS}/root/.kube/config
  fi

  ### POST 1.21 specific
  ######################
  helm repo add kubezero https://cdn.zero-downtime.net/charts/

  # if Calico, install multus to prepare migration
  kubectl get ds calico-node -n kube-system && \
    helm template kubezero/kubezero-network --version 0.1.0 --include-crds --namespace kube-system --kube-version $KUBE_VERSION --name-template network \
      --set multus.enabled=true \
      | kubectl apply -f - $LOG

  # migrate backup
  if [ -f ${HOSTFS}/usr/local/sbin/backup_control_plane.sh ]; then
    _repo=$(grep "export RESTIC_REPOSITORY" ${HOSTFS}/usr/local/sbin/backup_control_plane.sh)
    helm template kubezero/kubezero-addons --version 0.2.0 --include-crds --namespace kube-system --kube-version $KUBE_VERSION --name-template addons \
      --set clusterBackup.enabled=true \
      --set clusterBackup.repository="${_repo##*=}" \
      --set clusterBackup.password="$(cat ${HOSTFS}/etc/kubernetes/clusterBackup.passphrase)" \
    | kubectl apply -f - $LOG
  fi

  ######################


  # Cleanup after kubeadm on the host
  rm -rf /etc/kubernetes/tmp

  echo "Successfully upgraded cluster."

  # TODO
  # Send Notification currently done via CloudBender -> SNS -> Slack
  # Better deploy https://github.com/opsgenie/kubernetes-event-exporter and set proper routes and labels on this Job

  # Removed:
  # - update oidc do we need that ?


elif [[ "$1" =~ "^(bootstrap|recover|join)$" ]]; then

  render_kubeadm

  if [[ "$1" =~ "^(recover|join)$" ]]; then

    # Recert certificates for THIS node
    rm -f ${HOSTFS}/etc/kubernetes/pki/etcd/peer.* ${HOSTFS}/etc/kubernetes/pki/etcd/server.* ${HOSTFS}/etc/kubernetes/pki/apiserver.*
    kubeadm init phase certs etcd-server --config=/etc/kubernetes/kubeadm-etcd.yaml --rootfs ${HOSTFS}
    kubeadm init phase certs etcd-peer --config=/etc/kubernetes/kubeadm-etcd.yaml --rootfs ${HOSTFS}
    kubeadm init phase certs apiserver --config=/etc/kubernetes/kubeadm.yaml --rootfs ${HOSTFS}

    # Restore only etcd for desaster recovery
    if [[ "$1" =~ "^(recover)$" ]]; then
      etcdctl snapshot restore ${HOSTFS}/etc/kubernetes \
        --name $NODENAME \
        --data-dir="${HOSTFS}/var/lib/etcd" \
        --initial-cluster-token ${CLUSTERNAME} \
        --initial-advertise-peer-urls https://${NODENAME}:2380 \
        --initial-cluster $NODENAME=https://${NODENAME}:2380
    fi

  # Create all certs during bootstrap
  else
    kubeadm init phase certs all --config=/etc/kubernetes/kubeadm-etcd.yaml --rootfs ${HOSTFS}
  fi

  pre_kubeadm

  if [[ "$1" =~ "^(join)$" ]]; then
    kubeadm join --config /etc/kubernetes/JoinConfiguration.yaml --rootfs ${HOSTFS} \
      --experimental-patches /tmp/patches $LOG
  else
    kubeadm init --config /etc/kubernetes/kubeadm.yaml --rootfs ${HOSTFS} \
      --experimental-patches /tmp/patches --skip-token-print $LOG
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

  # Install some basics on bootstrap
  if [[ "$1" =~ "^(bootstrap)$" ]]; then
    helm repo add kubezero https://cdn.zero-downtime.net/charts/

    # network
    yq eval '.network // ""' ${HOSTFS}/etc/kubernetes/kubezero.yaml > _values.yaml
    helm template kubezero/kubezero-network --version 0.1.0 --include-crds --namespace kube-system --name-template network \
      -f _values.yaml --kube-version $KUBE_VERSION | kubectl apply -f - $LOG

    # addons
    yq eval '.addons // ""' ${HOSTFS}/etc/kubernetes/kubezero.yaml > _values.yaml
    helm template kubezero/kubezero-addons --version 0.2.0 --include-crds --namespace kube-system --name-template addons \
      -f _values.yaml --kube-version $KUBE_VERSION | kubectl apply -f - $LOG
  fi

  post_kubeadm

  echo "${1} cluster $CLUSTERNAME successfull."


# Since 1.21 we only need to backup etcd + /etc/kubernetes/pki !
elif [ "$1" == 'backup' ]; then
  mkdir -p ${WORKDIR}

  restic snapshots || restic init || exit 1

  # etcd
  export ETCDCTL_API=3
  export ETCDCTL_CACERT=${HOSTFS}/etc/kubernetes/pki/etcd/ca.crt
  export ETCDCTL_CERT=${HOSTFS}/etc/kubernetes/pki/apiserver-etcd-client.crt
  export ETCDCTL_KEY=${HOSTFS}/etc/kubernetes/pki/apiserver-etcd-client.key

  etcdctl --endpoints=https://localhost:2379 snapshot save ${WORKDIR}/etcd_snapshot

  # pki & cluster-admin access
  cp -r ${HOSTFS}/etc/kubernetes/pki ${WORKDIR}
  cp -r ${HOSTFS}/etc/kubernetes/admin.conf ${WORKDIR}

  # Backup via restic
  restic snapshots || restic init
  restic backup ${WORKDIR} -H $CLUSTERNAME

  echo "Backup complete"
  restic forget --keep-hourly 24 --keep-daily ${RESTIC_RETENTION:-7} --prune

elif [ "$1" == 'restore' ]; then
  mkdir -p ${WORKDIR}

  restic restore latest --no-lock -t /

  # Make last etcd snapshot available
  cp ${WORKDIR}/etcd_snapshot ${HOSTFS}/etc/kubernetes

  # Put PKI in place
  cp -r ${WORKDIR}/pki ${HOSTFS}/etc/kubernetes

  # Always use kubeadm kubectl config to never run into chicken egg with custom auth hooks
  cp ${WORKDIR}/admin.conf ${HOSTFS}/root/.kube/config

else
  echo "Unknown command!"
  exit 1
fi
