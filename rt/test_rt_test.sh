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
cat $trace_log|awk -v command=$command 'BEGIN{left=0;right=0}{if(match($0, "sched_switch")){if($NF != command){++left}else{++right}}}END{printf "left=%d, right=%d\n%s\n", left, right, $0}'
