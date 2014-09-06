#!/bin/bash
vm_user=root
notify_run=`dirname $0`/notify_run.sh
notify_check=`dirname $0`/notify_check.sh
nohup_run=`dirname $0`/nohup_run.sh
working_dir=/root/my-scripts/rt_task
utilization=50 #default 50% utilization of cpu
step=10 #default 10%
declare -a vm_ips
declare -a vm_pids
while getopts :v:p:u:l:n:c:s:h opt
do
	case $opt in
	v)
		vm_ip=`echo $OPTARG|cut -d, -f1`
		vm_pid=`echo $OPTARG|cut -d, -f2`
		vm_ips+=($vm_ip)
		vm_pids+=($vm_pid)
		;;
	p)
		vm_periods=`echo $OPTARG|sed 'y/,/ /'`
		;;
	u)
		utilization=$OPTARG
		;;
	s)
		step=$OPTARG
		;;
	l)
		log_dst=$OPTARG
		;;
	n)
		notify_user=`echo $OPTARG|cut -d, -f1`
		notify_ip=`echo $OPTARG|cut -d, -f2`
		notify_path=`echo $OPTARG|cut -d, -f3`
		;;
	c)
		cmd=$OPTARG
		;;
	h)
		host=1
		;;
	esac
done
if [ ${#vm_ips[@]} -ge 1 ] && [ ${#vm_pids[@]} -ge 1 ] && [ -n "$vm_periods" ] && [ -n "$utilization_step" ] && [ -n "$log_path" ] && [ -n "$notify_user" ] && [ -n "$notify_ip" ] && [ -n "$notify_path" ] && [ -n "$utilization_step" ] 
then
	num_vm=${#vm_ips[@]}
	#prepare log
	if [ -n "$host" ]
	then
		batchname="host_frequency"
	else
		batchname=$num_vm"_vm_frequency"
	fi

	for vm_period in $vm_periods
	do
		if [ $num_vm -eq 1 ]
		then
			vm_exec=$[ vm_period * $utilization / 100 ]
			
		elif [ $num_vm -eq 2 ]
		then

		else
			echo too many vms
			exit 1
		fi
		total_vm_exec=$[ vm_period * $utilization / 100 ]
		primary_vm_exec=$[ total_vm_exec * 50
	done
else
	echo "usage: $0 -v <vm1_ip>,<vm1_pid> -v <vm2_ip>,<vm2_pid> ... -p <vm_period1>,<vm_period2>... [-u <vm_utilization>] -l <log_dst> -n <notify_user>,<notify_ip>,<notify_path> -c <cmd> [-s <utilization_step>] -h"
fi


