#!/bin/bash
set -ex

REPO="kubernetes-sigs/aws-efs-csi-driver"
[ -z "$RELEASE" ] && RELEASE=$(curl -sL -s https://api.github.com/repos/${REPO}/releases | grep '"tag_name":' | cut -d'"' -f4 | grep -v -E "(alpha|beta|rc)" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)

rm -rf git
git clone https://github.com/$REPO.git git
cd git && git checkout $RELEASE && cd -

rm -rf charts && mkdir -p charts/aws-efs-csi-driver
mv git/helm/* charts/aws-efs-csi-driver
