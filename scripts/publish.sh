#!/bin/bash
set -ex

REPO_URL_S3="s3://zero-downtime-web-cdn/charts"
REPO_URL="https://cdn.zero-downtime.net/charts"

CHARTS=${1:-'.*'}

SRCROOT="$(cd "$(dirname "$0")/.." && pwd)"

TMPDIR=$(mktemp -d kubezero-repo.XXX)
mkdir -p $TMPDIR

[ -z "$DEBUG" ] && trap 'rm -rf $TMPDIR' ERR EXIT


function reset_index() {
  aws s3 sync $REPO_URL_S3/ $TMPDIR/
  helm repo index $TMPDIR --url $REPO_URL
  aws s3 cp $TMPDIR/index.yaml $REPO_URL_S3/ --cache-control max-age=1

  exit 0
}


function publish_chart() {
  for dir in $(find -L $SRCROOT/charts -mindepth 1 -maxdepth 1 -type d);
  do
      name=$(basename $dir)
      [[ $name =~ $CHARTS ]] || continue

      #if [ $(helm dep list $dir 2>/dev/null| wc -l) -gt 1 ]
      #then
      #    echo "Processing chart dependencies"
      #    rm -rf $dir/tmpcharts
      #    helm dependency update --skip-refresh $dir
      #fi

      echo "Processing $dir"
      helm lint $dir
      helm package -d $TMPDIR $dir
  done

  curl -L -s -o $TMPDIR/index.yaml ${REPO_URL}/index.yaml
  helm repo index $TMPDIR --url $REPO_URL --merge $TMPDIR/index.yaml

  for p in $TMPDIR/*.tgz; do
    aws s3 cp $p $REPO_URL_S3/
  done
  aws s3 cp $TMPDIR/index.yaml $REPO_URL_S3/ --cache-control max-age=1
}


#reset_index

publish_chart

CF_DIST=E11OFTOA3L8IVY
aws cloudfront create-invalidation --distribution $CF_DIST --paths "/charts/*"

