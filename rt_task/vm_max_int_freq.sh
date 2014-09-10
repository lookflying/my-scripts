#!/bin/bash
set_deadline=set_deadline
max_int_freq=./max_int_freq.sh
if [ $# -eq 4 ]
then
	host_ip=$1
	vm_pid=$2
	count=$3
	deadlines=$4
	deadlines=`echo $deadlines|sed 'y/,/ /'`
	echo -n -e "vm period\tvm utilization\tmax int freq\n"
	for deadline in $deadlines
	do
		ssh $host_ip "$set_deadline $vm_pid $deadline" &>/dev/null
		echo -n -e "${deadline/:/\t}\t"
		$max_int_freq $count|awk '{print $2}'
	done
else
	echo "usage:$0 <host_ip> <vm_pid> <count> <period1>:<exec1>,<period2>:<exec2>..."
fi
