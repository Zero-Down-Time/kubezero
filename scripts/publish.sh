#!/bin/bash
set -eu

CHARTS=${1:-'.*'}
# all credits go to the argoproj Helm guys https://github.com/argoproj/argo-helm

SRCROOT="$(cd "$(dirname "$0")/.." && pwd)"
GIT_PUSH=${GIT_PUSH:-true}

[ "$(git branch --show-current)" == "stable" ] || { echo "Helm packages should only be built from stable branch !"; exit 1; }

TMPDIR=$(mktemp -d kubezero-repo.XXX)
mkdir -p $TMPDIR/stage

git clone -b gh-pages ssh://git@git.zero-downtime.net:22000/ZeroDownTime/KubeZero.git $TMPDIR/repo
# Reset all
# rm -rf $TMPDIR/repo/*tgz $TMPDIR/repo/index.yaml

helm repo add argoproj https://argoproj.github.io/argo-helm
helm repo add jetstack https://charts.jetstack.io
helm repo add uswitch https://uswitch.github.io/kiam-helm-charts/charts/
helm repo update

for dir in $(find -L $SRCROOT/charts -mindepth 1 -maxdepth 1 -type d);
do
    name=$(basename $dir)
    [[ $name =~ $CHARTS ]] || continue
    if [ $(helm dep list $dir 2>/dev/null| wc -l) -gt 1 ]
    then
        echo "Processing chart dependencies"
        rm -rf $dir/tmpcharts
        helm dependency update --skip-refresh $dir
    fi

    echo "Processing $dir"
    helm lint $dir || true
    helm --debug package -d $TMPDIR/stage $dir
done

# Do NOT overwrite existing charts
cp -n $TMPDIR/stage/*.tgz $TMPDIR/repo

cd $TMPDIR/repo

helm repo index .
git status

if [ "$GIT_PUSH" == "true" ]
then
    git add . && git commit -m "Publish charts" && git push ssh://git@git.zero-downtime.net:22000/ZeroDownTime/KubeZero.git gh-pages
fi

cd -
rm -rf $TMPDIR
