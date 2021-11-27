ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

ARG KUBE_VERSION

RUN cd /etc/apk/keys && \
    wget "https://cdn.zero-downtime.net/alpine/stefan@zero-downtime.net-6183d596.rsa.pub" && \
    echo "@kubezero https://cdn.zero-downtime.net/alpine/v${KUBE_VERSION}/kubezero" >> /etc/apk/repositories && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk upgrade -U -a && \
    apk --no-cache add \
      yq \
      cri-tools@kubezero \
      kubeadm@kubezero \
      kubectl@kubezero \
      etcd-ctl@testing \
      restic@testing \
      helm@testing

ADD v${KUBE_VERSION}/kubezero.sh /usr/bin
ADD v${KUBE_VERSION}/kubeadm /opt/kubeadm

ENTRYPOINT ["kubezero.sh"]
