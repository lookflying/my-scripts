#!/bin/bash
if [ $# -eq 2 ]
then
	base_dst=$1
	new_dir=$2
	mkdir -p /tmp/$new_dir &>/dev/null
	if [ $? -ne 0 ]
	then
		echo fail to mkdir $new_dir
		exit 1
	fi
	echo $new_dir
	rsync -av /tmp/$new_dir $base_dst &>/dev/null
	if [ $? -ne 0 ]
	then
		echo can not access $base_dst
		rm -r /tmp/$new_dir
		exit 1
	else
		rm -r /tmp/$new_dir
	fi
else
	echo "usage: $0 <base_dst> <new_dir>"
fi
