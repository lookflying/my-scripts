#!/bin/bash
if [ $# -ge 2 ]
then
	log_dst=$1
	file_name=$2
	shift 2
	cmd=$@
	tmp_file=`mktemp`
	$cmd |tee $tmp_file
	rsync -av $tmp_file $log_dst/$file_name
	if [ $? -ne 0 ]
	then
		echo "fail to send file($tmp_file)  to $log_dst/$file_name"
	fi
else
	echo "usage: $0 <log_dst> <file_name> <cmd>..."
fi
