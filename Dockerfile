ARG ALPINE_VERSION=3.15

FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION
ARG KUBE_VERSION=1.22

RUN cd /etc/apk/keys && \
    wget "https://cdn.zero-downtime.net/alpine/stefan@zero-downtime.net-61bb6bfb.rsa.pub" && \
    echo "@kubezero https://cdn.zero-downtime.net/alpine/v${ALPINE_VERSION}/kubezero" >> /etc/apk/repositories && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk upgrade -U -a --no-cache && \
    apk --no-cache add \
      jq \
      yq \
      cri-tools@kubezero \
      kubeadm@kubezero~=${KUBE_VERSION} \
      kubectl@kubezero~=${KUBE_VERSION} \
      etcd-ctl@testing \
      restic@testing \
      helm@testing

ADD releases/v${KUBE_VERSION}/kubezero.sh /usr/bin
ADD charts/kubeadm /charts/kubeadm
ADD charts/kubezero-addons /charts/kubezero-addons
ADD charts/kubezero-network /charts/kubezero-network

ENTRYPOINT ["kubezero.sh"]
