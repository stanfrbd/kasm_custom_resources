#!/bin/bash
set -eou pipefail

mkdir -p /home/kasm-user/Desktop/toto

chown root:kvm /dev/kvm
service libvirtd start
# debug
echo "starting services" >> /home/kasm-user/Desktop/log.txt
service virtlogd start
rdp_ip=$(VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up | grep -Eo "192.168.121.[[:digit:]]+")
rdesktop $rdp_ip -u vagrant -p vagrant -f
exec "$@"
