#!/usr/bin/env bash

ORIG_DIR="$(pwd)"
cd "$(dirname "$0")"
BIN_DIR="$(pwd)"

trap "cd '${ORIG_DIR}'" EXIT

function set_hostname() {
  hostnamectl set-hostname "$1"
}

function write_etc_hosts() {
  cat - <<EOF >>/etc/hosts
192.168.111.11  gfs01
192.168.111.12  gfs02
EOF
}

function setup_software_sources() {
  apt-get -y update
  apt-get -y install software-properties-common
  add-apt-repository -y ppa:gluster/glusterfs-7
  apt-get -y update
}

function setup_gluster_service() {
  apt-get -y install glusterfs-server
  apt-get -y install glusterfs-client
}

function main() {
  test $# -lt 1 && echo "ERROR: not enough args" && return 1
  HOSTNAME="$1"

  set_hostname "$HOSTNAME"
  write_etc_hosts
  setup_software_sources
  setup_gluster_service
}

main "$@"