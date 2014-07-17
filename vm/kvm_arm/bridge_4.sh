#!/bin/bash
# bridge.sh

ifconfig|grep br0 || brctl addbr br0
while [ `ip link|grep tap|wc -l` -lt 4 ]
do
tunctl -u root
done

ifconfig eth0 0.0.0.0 up
ifconfig tap0 0.0.0.0 up
ifconfig tap1 0.0.0.0 up
ifconfig tap2 0.0.0.0 up
ifconfig tap3 0.0.0.0 up

brctl addif br0 eth0
brctl addif br0 tap0
brctl addif br0 tap1
brctl addif br0 tap2
brctl addif br0 tap3

ifconfig br0 10.42.0.100 netmask 255.255.255.0 broadcast 10.42.0.255
route add default gw 10.42.0.1
