#!/bin/bash
all_task_log=all_task_log.sh
split_log=split_log.sh
ref_columns=2,5
columns=2,5,7,22,10,24,18
column_nams=vm_period,task_period,task_exec,task_load,miss_rate,miss_rate_after_middle,thread_run
middle=splitted
if [ $# -eq 1 ]
then
	dir=$1
	logdirs=`find $dir -maxdepth 1 -mindepth 1 -type d`
	for logdir in $logdirs
	do
		echo $logdir
		name=${logdir%-raw}
		name=${name##*/}
		prefix=${logdir%/*}
		target_dir=$prefix/$middle/$name
		echo $target_dir
		$all_task_log $logdir|$split_log $target_dir $ref_columns $columns $column_nams
	
	done
else
	echo "usage $0 <dir>"
fi
