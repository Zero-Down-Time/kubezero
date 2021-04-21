#!/bin/bash
set -ex

export VERSION=0.0.6

rm -rf charts/gemini
helm pull fairwinds-stable/gemini --untar --untardir charts

# Patch for istiod to control plane
patch -p0 -i run-on-controller.patch --no-backup-if-mismatch
