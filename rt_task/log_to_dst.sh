#!/bin/bash
if [ $# -ge 2 ]
then
	log_dst=$1
	file_name_line=$2
	if [ $file_name_line -eq 0 ]
	then
		file_name=$3
		shift 3
	else
		shift 2
	fi
	cmd=$@
	tmp_file=`mktemp`
	$cmd |tee $tmp_file
	if [ -z "$file_name" ]
	then
		file_name=`sed -n "$file_name_line"p $tmp_file`".txt"
	fi
	rsync -av $tmp_file $log_dst/$file_name
	if [ $? -ne 0 ]
	then
		echo "fail to send file($tmp_file)  to $log_dst/$file_name"
	fi
else
	echo "usage: $0 <log_dst> <file_name_line> [<log_name>(when line = 0)] <cmd>..."
fi
