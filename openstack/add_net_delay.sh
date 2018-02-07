#!/bin/bash

delay=${1}
vlans=$(ip a | grep -oE 'vlan[0-9]{2}' | uniq)

# Delete all rules per interface
for i in ${vlans}; do
 echo "Deleteing all rules for $i"
 tc qdisc del dev ${i} root
done

sleep 1
echo "-------------------------------------"

# Add delay rule per vlan interface
for i in ${vlans}; do
 echo "Adding ${delay} delay for ${i}"
 tc qdisc add dev ${i} root handle 8000: prio
 tc qdisc add dev ${i} parent 8000:1 handle 8001: netem delay ${delay}ms
 tc filter add dev ${i} parent 8000: protocol ip prio 1 u32 match ip dst 172.17.0.0/16 flowid 8000:1
done
