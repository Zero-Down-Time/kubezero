#!/bin/bash

NAME=$1

POD_ID="$(crictl pods --name $NAME -q)"
CGROUP_PATH=$(crictl inspectp -o=json $POD_ID | jq -rc .info.runtimeSpec.linux.cgroupsPath)

echo -n "cgroup memory limit in bytes for $NAME: "
cat /sys/fs/cgroup/memory/$(dirname $CGROUP_PATH)/memory.limit_in_bytes
