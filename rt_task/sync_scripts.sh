#!/bin/bash
ips="192.168.1.59 192.168.1.60 192.168.1.61 192.168.1.62"
for ip in $ips
do
	echo sync scripts on $ip
	ssh root@$ip "cd ~/my-scripts;git pull origin master"
done
