#!/bin/bash

set -e

mounts="${@}"
HOSTS="${HOSTS:-*}"
PARAMS="${PARAMS:-(rw,sync,no_root_squash,no_subtree_check,insecure,fsid=0)}"

echo "nfs        2049/tcp   # Network File System" >> /etc/services 
echo "nfs        2049/udp   # Network File System" >> /etc/services
echo "sunrpc     111/tcp    portmapper   # RPC 4.0 portmapper" >> /etc/services 
echo "sunrpc     111/udp    portmapper" >> /etc/services

for mnt in "${mounts[@]}"; do
  src=$(echo $mnt | awk -F':' '{ print $1 }')
  mkdir -p $src
  echo "$src $HOSTS$PARAMS" >> /etc/exports
  echo "Added: $src $HOSTS$PARAMS"
done

exec runsvdir /etc/sv
