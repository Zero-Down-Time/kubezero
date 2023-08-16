ARG ALPINE_VERSION=3.18

FROM docker.io/alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION
ARG KUBE_VERSION=1.26

RUN cd /etc/apk/keys && \
    wget "https://cdn.zero-downtime.net/alpine/stefan@zero-downtime.net-61bb6bfb.rsa.pub" && \
    echo "@kubezero https://cdn.zero-downtime.net/alpine/v${ALPINE_VERSION}/kubezero" >> /etc/apk/repositories && \
    echo "@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk upgrade -U -a --no-cache && \
    apk --no-cache add \
      jq \
      yq \
      diffutils \
      bash \
      python3 \
      py3-yaml \
      restic \
      helm \
      cri-tools@kubezero \
      kubeadm@kubezero~=${KUBE_VERSION} \
      kubectl@kubezero~=${KUBE_VERSION} \
      etcdhelper@kubezero \
      etcd-ctl@edge-testing

RUN helm repo add kubezero https://cdn.zero-downtime.net/charts && \
    mkdir -p /var/lib/kubezero

ADD admin/kubezero.sh admin/libhelm.sh admin/migrate_argo_values.py /usr/bin
ADD admin/libhelm.sh admin/pre-upgrade.sh /var/lib/kubezero

ADD charts/kubeadm /charts/kubeadm
ADD charts/kubezero /charts/kubezero

ENTRYPOINT ["kubezero.sh"]
