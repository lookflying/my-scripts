#!/bin/bash
vm_utilization=50
precision=1000 #default 1000ns
utilization=50 #default 50%
duration=20 #default 20
log_switch=0
taskscript=`dirname $0`/run_rt_task_nano.sh
runlog="run.log"
last_pass_period=""
last_fail_period=0 #trick
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
function check_missed()
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
	return $missed	
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
function get_next_period()
{
	last_pass_period=$1
	last_fail_period=$2
	if [ -z "$last_pass_period" ]
	then
		return 1
	fi
	if [ $last_pass_period -ge $last_fail_period ]
	then
		if [ $[ $last_pass_period - $last_fail_period ] -ge $precision ]
		then
			next_period=$[ ($last_pass_period + $last_fail_period) / 2 ] 
			return 0
		else
			return 1
		fi
	fi
}
while getopts :s:t:u:l:c:p: opt
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
	p)
		precision=$OPTARG
		;;
	esac
done
if [ -n "$start_period" ] && [ -n "$threshold" ] && [ -n "$log_dst" ]
then	
#prepare logging
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
#start benchmark
	period=$start_period
	miss_ratio=100
	finished=0
	while [ $finished -eq 0 ]
	do
		budget=$[ $period * $vm_utilization / 100 ]
		execute=$[ $budget * $utilization / 100 ]
		retry_count=0
		while [ $retry_count -lt 2 ]
		do
			echo -n "period=$period"
			run_task $period $budget $execute $duration	$log_switch $log_dst/$batchname &> /dev/null
			miss_ratio=`get_task_miss_rate`
			miss_ratio=${miss_ratio%\%}
			echo -n -e "\tmiss_ratio=$miss_ratio%\n"
			check_missed
			if [ $missed -eq 0 ]
			then
				last_pass_period=$period
				break
			fi
			retry_count=$[ $retry_count + 1 ]
		done
		if [ $missed -eq 1 ]
		then
			last_fail_period=$period
		fi
		get_next_period $last_pass_period $last_fail_period
		finished=$?
		period=$next_period
	done
	echo "last_pass_period=$last_pass_period"
else
	echo "usage: $0 -s <start_period> -t <miss_ratio_threshold> -u [<utilization>] [-p <precision>] -l <log_dst> -c comment"
fi
