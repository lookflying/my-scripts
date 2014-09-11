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
while getopts :p:b:e:d:l: opt
do
	case $opt in
	p)
		echo period = $OPTARG ns
		period=$OPTARG
		;;
	b)
		echo budget = $OPTARG ns
		budget=$OPTARG
		;;
	e)
		echo execute = $OPTARG ns
		execute=$OPTARG
		;;
	d)
		echo duration = $OPTARG sec
		duration=$OPTARG
		;;
	l)
		echo log opt = $OPTARG
		log=$OPTARG
		;;
	esac
done

echo $command $period:$budget:$execute $duration $log 
#ignore other arguments
shift $[ $OPTIND - 1 ]
count=0
for param in $@
do
	count=$[ $count + 1 ]
done

#
cd /dev/shm
trace-cmd record -e 'sched_wakeup*' -e sched_switch -e 'sched_migrate*' $command $period:$budget:$execute $duration $log 2>/dev/null >$log_file
pid=`grep $pid_mark $log_file|awk '{print $1}'`
echo pid= $pid
echo -e -n "period=\t"$period"ns\n" 
echo -e -n "budget=\t"$budget"ns\t"
echo $budget $period|awk '{printf "%3.2f%%\n", $1/$2*100}'
echo -e -n "execute=\t"$execute"ns\t"
echo $execute $budget $period|awk '{printf "%3.2f%%\t%3.2f%%\n", $1/$2*100, $1/$3*100}'
begin=`grep "===begin===" -n $log_file|awk 'BEGIN{FS=":"}{print $1+1}'`
end=`grep "===end===" -n $log_file|awk 'BEGIN{FS=":"}{print $1-1}'`
if [ -n "$begin" ] && [ -n "$end" ]
then
	sed -n $begin", "$end"p" $log_file
fi

trace-cmd report -w -F "sched:common_pid==$pid || next_pid== $pid" 2>/dev/null| sed /^$/d > $trace_log
cat $trace_log|awk -v command=$command -v pid=$pid -v period=$period -v budget=$budget -v duration=$duration 'BEGIN{left=0;right=0;}{if(match($0, "sched_switch")){mid=index($0, "==>");pos=index($0, pid);if(pos < mid){++left}else{++right}}}END{printf "sched_from=\t%d\nsched_to=\t%d\n", left, right}'
sed  -n '/Average wakeup latency/,$p' $trace_log
