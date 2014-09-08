#!/bin/bash
set_deadline=set_deadline
max_int_freq=./max_int_freq
if [ $# -eq 3 ]
then
	host_ip=$1
	vm_pid=$2
	count=$3
	deadlines=$3
	deadlines=`echo $vm_info|column -ts,`
	echo -n -e "vm period\tvm utilization\tmax int freq\n"
	for deadline in $deadlines
	do
		ssh $host_ip "$set_deadline $vm_pid $deadline"
		echo -n -e "${deadline/:/ }\t"
		$max_int_freq $count|awk '{print $2}'
	done
else
	echo "usage:$0 <host_ip> <vm_pid> <count> <period1>:<exec1>,<period2>:<exec2>...
fi
