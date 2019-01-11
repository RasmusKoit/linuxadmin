#!/bin/bash

ip addr add 172.16.99.5/24 dev eth0
ip addr add 172.16.88.5/24 dev eth1

ip link set dev eth0 up
ip link set dev eth1 up

echo "EX 4, time to change network interfaces around"

echo "Exporting eth0 interface and getting eth1 mac address"
export INTERFACE=eth0
export MATCHADDR=`ifconfig -a | grep -i hwaddr | grep eth1 | awk {'print $5'}`

/lib/udev/write_net_rules eth0

export INTERFACE=eth1
export MATCHADDR=`ifconfig -a | grep -i hwaddr | grep eth0 | awp {'print $5}'`

/lib/udev/write_net_rules eth1

echo "Make your rules persistent"

echo '#' > /etc/udev/rules.d/75-persistent-net-generator.rules

udevadm control --reload-rules
udevadm trigger

rmmod e1000
modprobe e1000

systemctl restart networking

ip addr add 172.16.88.5/24 dev eth0
ip addr add 172.16.99.5/24 dev eth1

ip link set dev eth0 up
ip link set dev eth1 up

echo "Network interfaces are now changed with itself"