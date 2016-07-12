#!/bin/bash

set -e

mounts="${@}"
HOSTS="${HOSTS:-*}"
PARAMS="${PARAMS:-(rw,sync,no_root_squash,no_subtree_check,insecure,fsid=0)}"

modprobe nfs
# NFS default ports
echo "nfs        2049/tcp" >> /etc/services 
echo "nfs        2049/udp" >> /etc/services
echo "nfs        111/tcp" >> /etc/services 
echo "nfs        111/udp" >> /etc/services
# Ports to NFS Cluster and Client status
echo "nfs        1110/tcp" >> /etc/services 
echo "nfs        1110/udp" >> /etc/services
# Ports to NFS lock manager
echo "nfs        4045/tcp" >> /etc/services 
echo "nfs        4045/udp" >> /etc/services

for mnt in "${mounts[@]}"; do
  src=$(echo $mnt | awk -F':' '{ print $1 }')
  mkdir -p $src
  echo "$src $HOSTS$PARAMS" >> /etc/exports
  echo "Added: $src $HOSTS$PARAMS"
done

exec runsvdir /etc/sv
