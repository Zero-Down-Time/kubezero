#!/bin/bash
set -eux

CHARTS=${1:-'.*'}

SRCROOT="$(cd "$(dirname "$0")/.." && pwd)"

for dir in $(find -L $SRCROOT/charts -mindepth 1 -maxdepth 1 -type d);
do
    name=$(basename $dir)
    [[ $name =~ $CHARTS ]] || continue
    if [ $(helm dep list $dir 2>/dev/null| wc -l) -gt 1 ]
    then
        echo "Processing chart dependencies"
        rm -rf $dir/tmpcharts
        rm -rf $dir/charts/*.tgz
        helm dependency update --skip-refresh $dir
    fi

    echo "Processing $dir"
    helm lint $dir && helm --debug package $dir

    echo "Updating README"
    helm-docs -c $dir 
done
