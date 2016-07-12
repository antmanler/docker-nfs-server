#!/bin/bash

set -e

mounts="${@}"
HOSTS="${HOSTS:-*}"
PARAMS="${PARAMS:-(rw,sync,no_root_squash,no_subtree_check,insecure,fsid=0)}"

for mnt in "${mounts[@]}"; do
  src=$(echo $mnt | awk -F':' '{ print $1 }')
  mkdir -p $src
  echo "$src $HOSTS$PARAMS" >> /etc/exports
  echo "Added: $src $HOSTS$PARAMS"
done

exec runsvdir /etc/sv
