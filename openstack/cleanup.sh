#!/bin/bash

source /home/stack/overcloudrc

#delete instances
echo "Deleting Instances..."
for a in $(openstack server list -c ID -f value); do openstack server delete --wait $a; done

#delete floating IPs
echo "Deleting Flating IPs"
for j in $(openstack floating ip list -c ID -f value); do openstack floating ip delete $j; done

#clean images
echo "Deleting Images"
for b in $(openstack image list -c ID -f value); do openstack image delete $b;done

#clean routers
echo "Removing Interfaces from routers"
for c in $(openstack router list -c ID -f value);do
	echo "Cleaning router $c"
	for d in $(openstack subnet list -c ID -f value); do echo "Detaching Interface $d"; openstack router remove subnet $c $d; done
done

#delete routeres
echo "Deleting Routers"
for e in $(openstack router list -c ID -f value);do openstack router delete $e; done

#delete networks
echo "Deleting Networks"
for f in $(openstack network list -c ID -f value);do openstack network delete $f; done

#delete volume
echo "Deleting Volumes"
for g in $(openstack volume list -c ID -f value); do openstack volume delete $g; done

#delete keypair
echo "Deleting keypair"
for h in $(openstack keypair list -c Name -f value); do openstack keypair delete $h; done

#delete flavors
echo "Deleting Flavors"
for i in $(openstack flavor list -c ID -f value); do openstack flavor delete $i; done

