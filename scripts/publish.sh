#!/bin/bash
set -eux

# all credits go to the argoproj Helm guys https://github.com/argoproj/argo-helm

SRCROOT="$(cd "$(dirname "$0")/.." && pwd)"
GIT_PUSH=${GIT_PUSH:-false}

rm -rf $SRCROOT/output && git clone -b gh-pages ssh://git@git.zero-downtime.net:22000/ZeroDownTime/KubeZero.git $SRCROOT/output

helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo add argoproj https://argoproj.github.io/argo-helm

for dir in $(find $SRCROOT/charts -mindepth 1 -maxdepth 1 -type d);
do
    # Cleanup disabled as we have a un-released chart of argo-cd
    # rm -rf $dir/charts

    name=$(basename $dir)

    if [ $(helm dep list $dir 2>/dev/null| wc -l) -gt 1 ]
    then
        # Bug with Helm subcharts with hyphen on them
        # https://github.com/argoproj/argo-helm/pull/270#issuecomment-608695684
        if [ "$name" == "argo-cd" ]
        then
            echo "Restore ArgoCD RedisHA subchart"
            git checkout $dir
        fi
        echo "Processing chart dependencies"
        helm --debug dep build $dir
    fi

    echo "Processing $dir"
    helm --debug package $dir
done

cp $SRCROOT/*.tgz output/
cd $SRCROOT/output && helm repo index .

cd $SRCROOT/output && git status

if [ "$GIT_PUSH" == "true" ]
then
    cd $SRCROOT/output && git add . && git commit -m "Publish charts" && git push ssh://git@git.zero-downtime.net:22000/ZeroDownTime/KubeZero.git gh-pages
fi
