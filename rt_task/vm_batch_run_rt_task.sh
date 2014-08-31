#!/bin/bash
set_deadline=set_deadline
batch_run=batch_run_rt_task.sh
if [ $# -ge 4 ]
then
	vm_pid=$1
	host_ip=$2
	deadlines=$3
	deadlines=${deadlines//,/ }
	dir=${0%/*}
	shift 3
	for deadline in $deadlines
	do
		echo ssh $host_ip "$set_deadline $vm_pid $deadline"
		ssh $host_ip "$set_deadline $vm_pid $deadline"
		if [ $? -ne 0 ]
		then
			echo "set deadline failed"
			exit 1
		fi
#		sleep 1
		comment=`echo $deadline|sed 'y/:/_/'`
		echo $dir/$batch_run $@ -c $comment
		$dir/$batch_run $@ -c $comment
	done
else
	echo "usage: $0 <vm_pid> <host_ip> <period1>:<exec1>,<period2>:<exec2>,... <batch_run_arguments>..."
fi
