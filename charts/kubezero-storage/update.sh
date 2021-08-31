#!/bin/bash
set -ex

# Gemini
rm -rf charts/gemini
helm pull fairwinds-stable/gemini --untar --untardir charts

# Patch to run gemini on controller nodes
patch -p0 -i gemini.patch --no-backup-if-mismatch
