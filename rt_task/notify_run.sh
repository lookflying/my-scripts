#!/bin/bash
if [ $# -ge 2 ]
then
	notify_info=$1
	shift
	cmd=$@
	notify_user=`echo $notify_info|cut -d"," -f1`
	notify_ip=`echo $notify_info|cut -d"," -f2`
	notify_file=`echo $notify_info|cut -d"," -f3`
	echo 1|ssh $notify_user@$notify_ip "cat > $notify_file"
	if [ $? -ne 0 ]
	then
		echo fail to notify
		exit 1
	fi	
	$cmd
	echo 0|ssh $notify_user@$notify_ip "cat > $notify_file"
	if [ $? -ne 0 ]
	then
		echo fail to notify
		exit 1
	fi	
else
	echo "usage: $0 <notify_user>,<notify_ip>,<notify_path> <cmd>..."
fi
