#!/bin/bash
set -x
function test_log
{
	#sample test_log ./test_x264 abc.yuv x264 logdir abc.cfg
	if [ $# -ge 4 ] && [ -x $1 ]
	then
		if [ -f $5 ]
		then
			logfile=`./get_parameters.sh $2 $3 $5`
			parameters=$5" "`./get_parameters.sh $2 $5`
		else
			logfile=`./get_parameters.sh $2 $3`
			parameters=`./get_parameters.sh $2`
		fi
		if [ -d $4 ]
		then
			$1 $parameters >& $4/$logfile
		else
			$1 $parameters >& $logfile
		fi
	fi
}

function test_sequence
{
	if [ $# -eq 3 ]
	then
		test_log ./test_x264.sh $1 x264 $3
		for cfg in $2/*.cfg
		do
			test_log ./test_hevc.sh $1 hevc $3 $cfg
		done
	fi
}

max_task=1	#default
task_queue=""
task_count=0

function add_task
{
	task_queue="$task_queue $1"
	task_count=`expr $task_count + 1`
}

function check_task_queue
{
	old_task_queue=$task_queue
	task_count=0
	task_queue=""
	for task_pid in $old_task_queue
	do
		if [ -d /proc/$task_pid ]
		then
			add_task $task_pid
		fi
	done
}




if [ $# -ge 3 ] && [ -d $1 ]
then
	if [ $# -eq 4 ]
	then
		max_task=$4
	fi
	for seq in $1/*.yuv
	do
		$0 $seq $2 $3 &
		add_task $!
		while [ $task_count -ge $max_task ]
		do
			check_task_queue
			sleep 1
		done
	done
	wait
elif [ $# -ge 3 ] && [ -f $1 ]
then
	test_sequence $@
else
	echo usage: $0 sequencefile cfgdir logdir max_task
	echo usage: $0 sequencedir cfgdir logdir max_task
fi

