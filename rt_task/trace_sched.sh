#!/bin/bash
if [ $# -eq 1 ]
then
	pid=$1
	trace_log=trace.log
	trace_dir=/dev/shm/host_trace
	sched_log=sched.log
	cd /dev/shm
	mkdir -p $trace_dir
	cd $trace_dir
	trace-cmd record -e 'sched_wakeup*' -e sched_switch -e 'sched_migrate*' 2>/dev/null
	
	if [ -f "$trace_dir/trace.dat" ]
	then
		trace-cmd report -w -F "sched:common_pid==$pid || next_pid==$pid" 2>/dev/null > $trace_log 2>/dev/null
		cat $trace_log|awk -v pid=$pid 'BEGIN{left=0;right=0;}{if(match($0, "sched_switch")){mid=index($0, "==>");pos=index($0, pid);if(pos < mid){++left}else{++right}}}END{printf "sched_from=\t%d\nsched_to=\t%d\n", left, right}' |tee $sched_log
	else
		exit 1
	fi
else
	echo "usage: $0 <pid>"
fi

