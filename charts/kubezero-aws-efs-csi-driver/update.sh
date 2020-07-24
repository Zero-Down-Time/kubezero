#!/bin/bash
set -ex

REPO="kubernetes-sigs/aws-efs-csi-driver"
LATEST_RELEASE=$(curl -sL -s https://api.github.com/repos/${REPO}/releases | grep '"tag_name":' | cut -d'"' -f4 | grep -v -E "(alpha|beta|rc)" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)

URL="https://github.com/${REPO}/releases/download/${LATEST_RELEASE}/helm-chart.tgz"

rm -rf charts && mkdir -p charts/aws-efs-csi-driver
curl -sL "$URL" | tar xz -C charts/aws-efs-csi-driver --strip-components=1
