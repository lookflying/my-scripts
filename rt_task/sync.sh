#!/bin/bash
ips="192.168.1.22 192.168.1.59 192.168.1.60 192.168.1.61 192.168.1.62"
function sync_script()
{
	ip=$1
	echo sync scripts on $ip
	ssh root@$ip "cd ~/my-scripts;git pull origin master"
}
function sync_utility()
{
	ip=$1
	echo sync utility on $ip
	ssh root@$ip "cd ~/my-utility;git pull origin master;make"
}
for ip in $ips
do
	sync_script $ip &
	sync_utility $ip &
done
wait


