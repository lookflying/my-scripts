#!/bin/bash
vm_utilization=50
utilization=50 #default 50%
duration=20 #default 20
log_switch=0
taskscript=`dirname $0`/rt_task.sh
runlog="run.log"
function run_task()
{
	period=$1
	budget=$2
	execute=$3
	duration=$4
	log=$5
	dst=$6
	taskname=$period"_"$budget"_"$execute"_"$duration
	$taskscript -p$period -b$budget -e$execute -d$duration -l$log |tee /dev/shm/$runlog
	rsync /dev/shm/*.log /dev/shm/*.dat $dst/$taskname
	if [ $? -ne 0 ]
	then
		echo fail to rsync to $dst/$taskname @ `date +"%Y-%m-%d %H:%M:%S"`
	fi
}
function get_task_miss_rate()
{
	grep "miss_cnt_after_middle=" /dev/shm/$runlog|awk '{print $3}'
}
function check_finished()
{
	try_count=$3
	period=$4
	missed=`awk -v miss_ratio=$1 -v threshold=$3 '
	{
		if (miss_ratio >= threshold)
		{
			print 1
		}
		else
		{
			print 0
		}
	}	'`
	if [ $missed -eq 1 ]
	then
		try_count=$[ $try_count + 1 ]
		if [ $try_count -ge 3 ]
		then
			echo 1
		else
			echo 0
		fi
	else
		period=$[ $period / 2 ]
		if [ $period -lt 1 ]
		then
			echo 1
			return
		fi	
		try_count=0
		echo 0
	fi
}
while getopts :s:t:u:l: opt
do
	case $opt in
	s)
		start_period=$OPTARG
		;;
	t)
		threshold=$OPTARG
		;;
	u)
		utilization=$OPTARG
		;;
	l)
		log_dst=$OPTARG
		;;
	c)
		comment=$OPTARG
		;;
	esac
done
if [ -n "$start_period" ] && [ -n "$threshold" ] && [ -n "$log_dst" ]
then	
	taskname=`date +%Y%m%d_%H%M%S-`$comment	
	mkdir -p $taskname &>/dev/null
	if [ $? -ne 0 ]
	then
		echo fail to mkdir $taskname
		exit 1
	fi
	echo $taskname
	rsync -av $taskname $log_dst &>/dev/null
	if [ $? -ne 0 ]
	then
		echo can not access $log_dst
		exit 1
	fi
	rm -r $taskname
	period=$start_period
	miss_ratio=0
	try_count=0

	finished=`check_finished $miss_ratio $try_count $threshold $period`
	while [ $finished -eq 0 ]
	do
		echo "period=$period"
		budget=$[ $period * $vm_utilization / 100 ]
		execute=$[ $budget * $utilization / 100 ]
		run_task $period $budget $execute $duration	
		miss_ratio=`get_task_miss_rate`
		miss_ratio=${miss_ratio%\%}
		finished=`check_finished $miss_ratio $try_count $threshold`
	done
else
	echo "usage: $0 -s <start_period> -t <miss_ratio_threshold> -u [<utilization>] -l <log_dst> -c comment"
fi
