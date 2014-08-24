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
trace-cmd record -e 'sched_wakeup*' -e sched_switch -e 'sched_migrate*' $command $period:$budget:$execute $duration $log 2>/dev/null >$log_file
pid=`grep $pid_mark $log_file|awk '{print $1}'`
echo pid= $pid
echo -e -n "period=\t"$period"000 ns\n" 
echo -e -n "budget=\t"$budget"000 ns\n"
echo -e -n "execute=\t"$execute"000 ns\n"
begin=`grep "===begin===" -n $log_file|awk 'BEGIN{FS=":"}{print $1+1}'`
end=`grep "===end===" -n $log_file|awk 'BEGIN{FS=":"}{print $1-1}'`

sed -n $begin", "$end"p" $log_file

trace-cmd report -w -F "sched:common_pid==$pid || next_pid== $pid" 2>/dev/null| sed /^$/d > $trace_log
#cat $trace_log|awk -v command=$command 'BEGIN{left=0;right=0}{if(match($0, "sched_switch")){if($NF != command){++left}else{++right}}}END{printf "left=%d, right=%d\n%s\n", left, right, $0}'
#cat $trace_log|awk -v command=$command -v pid=$pid 'BEGIN{left=0;right=0;state=0;sum=0;last}{if(match($0, "sched_switch")){mid=index($0, "==>");pos=index($0, pid ":");if(pos < mid){++left;if(state==1){sum+=0}if(left==1){state=1}}else{++right}}}END{printf "left=%d, right=%d\n%s\n", left, right, $0}'
#cat $trace_log|awk -v command=$command -v pid=$pid -v period=$period -v budget=$budget -v duration=$duration 'BEGIN{left=0;right=0;state=0;sum=0;last}{if(match($0, "sched_switch")){ts=substr($3, 0, length($3));mid=index($0, "==>");pos=index($0, pid ":");if(pos < mid){++left;if(state==1){sum+=ts}if(left==1){state=1}}else{++right;if(state==1){sum-=ts}}}}END{printf "left=%d, right=%d, total = %f ses, buget = %f\n%s\n", left, right, sum, duration * 1000000 / preriod * 1 / budget, $0}'
#cat $trace_log|awk -v command=$command -v pid=$pid -v period=$period -v budget=$budget -v duration=$duration 'BEGIN{left=0;right=0;state=0;sum=0;last}{if(match($0, "sched_switch")){ts=substr($3, 0, length($3));mid=index($0, "==>");pos=index($0, pid ":");if(pos < mid){++left;if(state==1){sum+=ts}if(left==1){state=1}}else{++right;if(state==1){sum-=ts}}}}END{printf "left=%d, right=%d, total = %f sec, buget = %f sec\n%s\n", left, right, sum, duration * 1000000 / period * 1 * budget / 1000000, $0}'
cat $trace_log|awk -v command=$command -v pid=$pid -v period=$period -v budget=$budget -v duration=$duration 'BEGIN{left=0;right=0;}{if(match($0, "sched_switch")){mid=index($0, "==>");pos=index($0, pid);if(pos < mid){++left}else{++right}}}END{printf "sched_from=\t%d\nsched_to=\t%d\n%s\n", left, right, $0}'
