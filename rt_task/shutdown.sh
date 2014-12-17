#!/bin/bash
ips="192.168.1.59 192.168.1.60 192.168.1.61 192.168.1.62"
function shutdown_vm()
{
	ip=$1
	echo shutdown $ip
	ssh root@$ip "poweroff"
}
for ip in $ips
do
	shutdown_vm $ip &
done
wait


