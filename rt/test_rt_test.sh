#!/bin/bash
period=10000
budget=200
execute=0
duration=2
log=0
log_file=rt_task.log
trace_log=trace.log
command=rt_task
pid_mark="===pid==="

cd /dev/shm
trace-cmd record -e 'sched_wakeup*' -e sched_switch -e 'sched_migrate*' $command $period:$budget:$execute $duration $log >$log_file
pid=`grep $pid_mark $log_file|awk '{print $1}'`
#echo $pid

trace-cmd report -w -F "sched:common_pid==$pid || next_pid== $pid"| sed /^$/d > $trace_log
#cat $trace_log|awk -v command=$command 'BEGIN{left=0;right=0}{if(match($0, "sched_switch")){if($NF != command){++left}else{++right}}}END{printf "left=%d, right=%d\n%s\n", left, right, $0}'
#cat $trace_log|awk -v command=$command -v pid=$pid 'BEGIN{left=0;right=0;state=0;sum=0;last}{if(match($0, "sched_switch")){mid=index($0, "==>");pos=index($0, pid ":");if(pos < mid){++left;if(state==1){sum+=0}if(left==1){state=1}}else{++right}}}END{printf "left=%d, right=%d\n%s\n", left, right, $0}'
cat $trace_log|awk -v command=$command -v pid=$pid 'BEGIN{left=0;right=0;state=0;sum=0;last}{if(match($0, "sched_switch")){ts=substr($3, 0, length($3));mid=index($0, "==>");pos=index($0, pid ":");if(pos < mid){++left;if(state==1){sum+=ts}if(left==1){state=1}}else{++right;if(state==1){sum-=ts}}}}END{printf "left=%d, right=%d, total = %f ses\n%s\n", left, right, sum, $0}'
