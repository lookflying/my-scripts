#!/bin/bash
if [ $# -ge 1 ]
then
	target_dir=$1
	ref_column=$2
	key_list=""
	mkdir -p $target_dir
	while read line
	do
		key=`echo $line|awk -v col=$ref_column '{print $col}'`
		echo $key
		echo $line >> $target_dir/$key".txt"
	done
else
	echo "usage $0 target_dir reference_column"
fi
