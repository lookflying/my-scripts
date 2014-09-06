#!/bin/bash
vm_utilization=50
utilization=50 #default 50%
duration=20 #default 20
log_switch=0
taskscript=`dirname $0`/run_rt_task_nano.sh
runlog="run.log"
function run_task()
{
	dst=$6
	taskname=$period"_"$budget"_"$execute"_"$duration
	$taskscript -p$period -b$budget -e$execute -d$duration -l$log_switch |tee /dev/shm/$runlog
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
	missed=`echo "$miss_ratio $threshold"|awk '
	{
		if ($1 >= $2)
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
			return 1
		else
			return 0
		fi
	else
		period=$[ $period / 2 ]
		if [ $period -lt 1 ]
		then
			return 1
		else
			try_count=0
			return 0
		fi	
	fi
}
while getopts :s:t:u:l:c: opt
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
	batchname=`date +%Y%m%d_%H%M%S-`$comment	
	mkdir -p $batchname &>/dev/null
	if [ $? -ne 0 ]
	then
		echo fail to mkdir $batchname
		exit 1
	fi
	echo $batchname
	rsync -av $batchname $log_dst &>/dev/null
	if [ $? -ne 0 ]
	then
		echo can not access $log_dst
		exit 1
	fi
	rm -r $batchname
	period=$start_period
	miss_ratio=100
	try_count=0
	check_finished
	finished=$?
	while [ $finished -eq 0 ]
	do
		echo -n "period=$period"
		budget=$[ $period * $vm_utilization / 100 ]
		execute=$[ $budget * $utilization / 100 ]
		run_task $period $budget $execute $duration	$log_switch $log_dst/$batchname >/dev/null
		miss_ratio=`get_task_miss_rate`
		miss_ratio=${miss_ratio%\%}
		echo -n -e "\tmiss_ratio=$miss_ratio%\n"
		check_finished
		finished=$?
	done
else
	echo "usage: $0 -s <start_period> -t <miss_ratio_threshold> -u [<utilization>] -l <log_dst> -c comment"
fi
