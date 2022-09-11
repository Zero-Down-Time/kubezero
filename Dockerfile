ARG ALPINE_VERSION=3.16

FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION
ARG KUBE_VERSION=1.23

RUN cd /etc/apk/keys && \
    wget "https://cdn.zero-downtime.net/alpine/stefan@zero-downtime.net-61bb6bfb.rsa.pub" && \
    echo "@kubezero https://cdn.zero-downtime.net/alpine/v${ALPINE_VERSION}/kubezero" >> /etc/apk/repositories && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk upgrade -U -a --no-cache && \
    apk --no-cache add \
      jq \
      yq \
      diffutils \
      bash \
      python3 \
      py3-yaml \
      cri-tools@kubezero \
      kubeadm@kubezero~=${KUBE_VERSION} \
      kubectl@kubezero~=${KUBE_VERSION} \
      etcdhelper@kubezero \
      etcd-ctl@testing \
      restic@testing \
      helm@testing

RUN helm repo add kubezero https://cdn.zero-downtime.net/charts

ADD admin/kubezero.sh admin/libhelm.sh /usr/bin
ADD charts/kubeadm /charts/kubeadm
ADD charts/kubezero /charts/kubezero

ENTRYPOINT ["kubezero.sh"]
