#!/bin/bash
all_task_log=all_task_log.sh
split_log=split_log.sh
ref_columns=2,5
columns=2,5,7,22,10,24
column_nams=vm_period,task_period,task_exec,task_load,miss_rate,miss_rate_after_middle
middle=splitted
if [ $# -eq 1 ]
then
	logdir=$1
	echo $logdir
	name=${logdir%/}
	newname=${name%_raw}
	if [ "$newname" != "$name" ]
	then
		target_dir=$newname
	else
		target_dir=$name"_"$middle
	fi
	echo $target_dir
	$all_task_log $logdir|$split_log $target_dir $ref_columns $columns $column_nams

else
	echo "usage $0 <dir>"
fi
