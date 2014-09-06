#!/bin/bash
precision=1000 #default 1000ns
utilization=50 #default 50%
run_frequency=`dirname $0`/bisection_frequency.sh
set_deadline=set_deadline
while getopts :s:t:u:l:c:p:v:h:i: opt
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
	v)
		vm_period=${OPTARG%%:*}
		vm_exec=${OPTARG##*:}
		;;
	h)
		host_ip=$OPTARG
		;;
	i)
		vm_pid=$OPTARG
		;;
	esac
done
if [ -n "$start_period" ] && [ -n "$threshold" ] && [ -n "$log_dst" ] && [ -n $host_ip ] && [ -n $vm_period ] && [ -n $vm_exec ] && [ -n $vm_pid ]
then
	#prepare logging
	vm_ip=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`
	vm_comment=$vm_ip"-"$vm_pid"-"$vm_period"_"$vm_exec${comment:+"-"$comment}
	
	#set deadline
	ssh $host_ip "$set_deadline $vm_pid $vm_period:$vm_exec"
	if [ $? -ne 0 ]
	then
		echo "set deadline failed"
		exit 1
	fi
	
	#run frequency
	$run_frequency -s $start_period -t $threshold -u $utilization -p $precision -l $log_dst -c $vm_comment
else
	echo "usage: $0 -h <host_ip> -v <vm_period>:<vm_exec> -i <vm_pid> -s <start_period> -t <miss_ratio_threshold> -u [<utilization>] [-p <precision>] -l <log_dst> [-c <comment>]"
fi
