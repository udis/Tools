#!/bin/bash

openstack flavor create --ram 1024 --disk 5 --vcpus 1 m1.med
 
wget http://mirror.isoc.org.il/pub/fedora/releases/27/CloudImages/x86_64/images/Fedora-Cloud-Base-27-1.6.x86_64.qcow2 && openstack image create --disk-format qcow2 --file Fedora-Cloud-Base-27-1.6.x86_64.qcow2 fedora27
 
openstack network create --external --provider-network-type flat --provider-physical-network datacentre public
 
openstack subnet create public-sub --subnet-range 10.0.0.0/24 --allocation-pool start=10.0.0.200,end=10.0.0.250 --dns-nameserver 10.35.255.14 --network public
 
openstack network create internal-net
 
openstack subnet create --subnet-range 192.168.100.0/24 --network internal-net --dns-nameserver 10.35.28.28 --no-dhcp internal-subnet
 
openstack router create router-1
 
openstack router add subnet router-1 internal-subnet
 
openstack router set --external-gateway public router-1
 
#$ cat user_data
#cloud-config
#password: fedora
#chpasswd: { expire: False }
 
openstack server create --image fedora27 --flavor m1.med --nic net-id=$(openstack network show -c id -f value internal-net) fedora-$(echo $RANDOM) --user-data user_data --config-drive True
