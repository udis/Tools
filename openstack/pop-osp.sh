#!/bin/bash

##### To implement - setup ext-net if needed ####
#openstack network create --external --provider-network-type flat --provider-physical-network datacentre public
#openstack subnet create public-sub --subnet-range 10.0.0.0/24 --allocation-pool start=10.0.0.200,end=10.0.0.250 --dns-nameserver 10.35.255.14 --network public
#
#
#
#######################################################

source /home/stack/overcloudrc

openstack flavor create --ram 512 --disk 1 --vcpus 1 m1.small

#wget http://mirror.isoc.org.il/pub/fedora/releases/22/Cloud/x86_64/Images/Fedora-Cloud-Base-22-20150521.x86_64.qcow2 && openstack image create --disk-format qcow2 --file Fedora-Cloud-Base-22-20150521.x86_64.qcow2 fedora

wget https://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img && openstack image create --disk-format raw --file cirros-0.3.5-x86_64-disk.img cirros-0.3.5

openstack network create internal-net

openstack subnet create --subnet-range 192.168.100.0/24 --network internal-net --dns-nameserver 10.35.28.28 internal-subnet

openstack router create router-1

openstack router add subnet router-1 internal-subnet
#neutron router-interface-add router-1 internal-subnet
openstack router set --external-gateway public router-1
#neutron router-gateway-set router-1 public

openstack volume create --size 1 vol1

openstack floating ip create public

openstack server create --image cirros-0.3.5 --flavor m1.small --nic net-id=$(openstack network show -c id -f value internal-net) ciross-$(echo $RANDOM)

sleep 30

openstack server add volume $(openstack server list -c ID -f value) vol1

openstack server add floating ip $(openstack server list -c ID -f value) $(openstack floating ip list -c "Floating IP Address" -f value)

###### Fix Security group ########
#nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
###################################

sleep 3
echo ""
echo ""

ping $(openstack floating ip list -c "Floating IP Address" -f value)

