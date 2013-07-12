#!/bin/bash
names=""
for p in $@
do
	names=$names$p"*"
done

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
