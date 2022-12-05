#!/bin/bash
#set -x

POD_IDS=($(crictl pods -q))
POD_UIDS=()

for POD_ID in ${POD_IDS[@]}; do
  JSONDUMP="`crictl inspectp ${POD_ID}`"
  POD_NAME="`echo ${JSONDUMP} | jq -r '.status.metadata.name'`"
  POD_UID="`echo ${JSONDUMP} | jq -r '.info.runtimeSpec.annotations."io.kubernetes.pod.uid"'`"
  POD_UIDS+=($POD_UID)
done

# echo ${POD_UIDS[*]}

CGROUPS=($(find /sys/fs/cgroup/pids/kubepods/*/pod* -type d -depth))
CGROUPS+=($(find /sys/fs/cgroup/kubepods/*/pod* -type d -depth))

DELETED=0
for cg in ${CGROUPS[*]}; do
  valid=0
  for uid in ${POD_UIDS[*]}; do
    echo $cg | grep -q $uid && { valid=1; break; }
  done

  if [ $valid -eq 0 ]; then
    rmdir $cg
    ((DELETED=DELETED+1))
  fi
done

echo "Removed $DELETED left over cgroup folders."
