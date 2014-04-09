#!/bin/bash
#set -x
if [ $# -ge 2 ] && [ -d $1 ]
then
	dir=$1
	shift
fi
names=""
for p in $@
do
	names=$names$p"*"
done
if [ -n $dir ]
then
	names=$dir/$names
fi
for name in $names
do
	if [ -f $name ]
	then
		echo file: $name  exists
	elif [ -d $name ]
	then
		echo dir: $name exists
	else
		echo $name doesn\'t exist
	fi
done
