#!/bin/bash
vm_user=root
#vm_user=lookflying
notify_run=notify_run.sh
batch_run=batch_run_rt_task.sh
#batch_run=longrun.sh
working_dir=/root/my-scripts/rt_task
#working_dir=/home/lookflying/my-scripts/rt_task
if [ $# -ge 2 ]
then
	vms=$1
	notify_info=$2
	vms=${vms//,/ }
	shift 2
	for vm in $vms
	do
		ssh $vm_user@$vm <<-END_OF_CMD
			cd $working_dir 
			nohup ./$notify_run $notify_info/$vm ./$batch_run $@ >/dev/null &
		END_OF_CMD
#		ssh $vm_user@$vm "cd $working_dir;nohup ./$notify_run $notify_info/$vm ./$batch_run $@ &;exit" &
	done
	running=1
	notify_user=`echo $notify_info|cut -d"," -f1`
	notify_ip=`echo $notify_info|cut -d"," -f2`
	notify_path=`echo $notify_info|cut -d"," -f3`
	begin=`date +%s`
	while [ $running -eq 1 ]
	do
		sleep 1
		running=0
		for vm in $vms
		do
			state=`ssh $notify_user@$notify_ip "cat $notify_path/$vm"`
			if [ $? -ne 0 ]
			then
				running=1
				break
			fi
			if [ $state -ne 0 ]
			then
				running=1
				break
			fi
			continue
		done
	done
	end=`date +%s`
	echo last `expr $end - $begin` sec
else
	echo "usage: $0 <vm_ip1>,<vm_ip2> <notify_user>,<notify_ip>,<notify_path> <script_arguments>..."
fi
