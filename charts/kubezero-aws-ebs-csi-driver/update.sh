#!/bin/bash
set -ex

# Upstream doesnt have proper Helm repo yet so we just download latest release and stuff it into charts

REPO="kubernetes-sigs/aws-ebs-csi-driver"
[ -z "$RELEASE" ] && RELEASE=$(curl -sL -s https://api.github.com/repos/${REPO}/releases | grep '"tag_name":' | cut -d'"' -f4 | grep -v -E "(alpha|beta|rc)" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)

rm -rf git
git clone https://github.com/$REPO.git git
cd git && git checkout $RELEASE && cd -

rm -rf charts/aws-ebs-csi-driver && mkdir -p charts/aws-ebs-csi-driver
mv git/aws-ebs-csi-driver/* charts/aws-ebs-csi-driver
