#!/bin/bash
duration=20
log_switch=0
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
while getopts :u:l:c:b: opt
do
	case $opt in
	u)
		utilization=$OPTARG
		;;
	l)
		log_dst=$OPTARG
		;;
	c)
		comment=$OPTARG
		;;
	b)
		budget_utilization=$OPTARG
		;;
	esac
done
shift $[ $OPTIND - 1 ]

periods=$@

if [ -n "$utilization" ] && [ -n "$log_dst" ] && [ -n "$comment" ] && [ -n "$periods" ]
then
	#prepare log dir
	batchname=`date +%Y%m%d_%H%M%S-`"frequency-miss_ratio-"$comment
	mkdir -p /tmp/$batchname &>/dev/null
	if [ $? -ne 0 ]
	then
		echo fail to mkdir $batchname
		exit 1
	fi
	echo $batchname
	rsync -av /tmp/$batchname $log_dst &>/dev/null
	if [ $? -ne 0 ]
	then
		echo can not access $log_dst
		exit 1
	fi
	rm -r /tmp/$batchname
	#benchmark
	for period in $periods
		budget=$[ $period * $budget_utilization / 100 ]
		execute=$[ $period * $utilization / 100 ]
		run_task $period $budget $execute $duration	$log_switch $log_dst/$batchname &> /dev/null
	echo 
else
	echo "usage:	$0 -u <utilization> -b <budget_utilization> -l <log_dst> -c <comment> <period1> <period2> ..."
fi
