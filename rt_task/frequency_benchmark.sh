#!/bin/bash
function echo_run()
{
	echo $@
	$@
	echo
}
user=root
notify_run=./notify_run.sh
notify_check=`dirname $0`/notify_check.sh
nohup_run=`dirname $0`/nohup_run.sh
prepare_log=`dirname $0`/prepare_log_dst.sh
run_frequency=./bisection_frequency.sh
#run_frequency=./longrun.sh
single_vm_frequency=./single_vm_frequency.sh
#single_vm_frequency=./longrun.sh
log_to_dst=./log_to_dst.sh
trace_sched=./trace_sched.sh
run_rt_task=./run_task_kill.sh
kill_trace_cmd=./kill_trace_cmd.sh
max_int_freq=./int_freq_kill.sh

host_ip=192.168.1.22
host_working_dir=/root/mnt/my-scripts/rt_task
vm1_ip=192.168.1.20
vm2_ip=192.168.1.24
vm_working_dir=/root/my-scripts/rt_task
log_base=lookflying@192.168.1.3:/home/lookflying/work/log
notify_info=lookflying,192.168.1.3,/dev/shm
notify_user=lookflying
notify_ip=192.168.1.3
notify_path=/dev/shm
host_log_dir=`date +%Y%m%d`-host-frequency
single_vm_log_dir=`date +%Y%m%d`-single_vm-frequency
dual_vm_log_dir=`date +%Y%m%d`-dual_vm-frequency
trace_log_dir=`date +%Y%m%d`-trace_log
for key in $host_ip $vm1_pid $vm2_pid
do
	rm -rf $notify_path/$key
done
$prepare_log $log_base $host_log_dir
$prepare_log $log_base $single_vm_log_dir
$prepare_log $log_base $dual_vm_log_dir
$prepare_log $log_base $trace_log_dir

#host
#echo_run $nohup_run $user@$host_ip $host_working_dir $notify_run $notify_info $log_to_dst $log_base/$host_log_dir 1 $run_frequency -s 1000000 -t 1 -u 0 -p 1000 -l $log_base/$host_log_dir -c host 
#echo_run $notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $host_ip 
#
##$nohup_run $user@$host_ip $host_working_dir $notify_run $notify_info $log_to_dst $log_base/$host_log_dir 1 $run_frequency -s 1000000 -t 1 -u 0 -p 5 -l $log_base/$host_log_dir -c host 
##$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $host_ip 
#
#echo_run $nohup_run $user@$host_ip $host_working_dir $notify_run $notify_info $log_to_dst $log_base/$host_log_dir 1 $run_frequency -s 1000000 -t 1 -u 50 -p 1000 -l $log_base/$host_log_dir -c host 
#echo_run $notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $host_ip 
#
##$nohup_run $user@$host_ip $host_working_dir $notify_run $notify_info $log_to_dst $log_base/$host_log_dir 1 $run_frequency -s 1000000 -t 1 -u 50 -p 5 -l $log_base/$host_log_dir -c host 
##$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $host_ip 

vm1_pid=`ssh $user@$host_ip "cat /run/guest.tid"`
if [ $? -ne 0 ]
then
	echo cannot get vm1 pid
	exit 1
fi
#for task_period in  400000 800000 1000000 2000000
#for task_period in 100000 200000 300000
#for task_period in 250000
#do
#	task_budget=$[ $task_period / 2 ]
#	task_exec=0
#	echo_run mkdir -p /home/lookflying/work/log/$trace_log_dir/$task_period
#	echo_run $nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$trace_log_dir/$task_period 0 "guest_sched.txt" $run_rt_task -p$task_period -b$task_budget -e$task_exec -d20 -l0 
#	echo_run $nohup_run $user@$host_ip $host_working_dir $notify_run $notify_info $log_to_dst $log_base/$trace_log_dir/$task_period 0 "host_sched.txt" $trace_sched $vm1_pid
#	echo_run $notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $host_ip
##	echo_run $nohup_run $user@$host_ip $host_working_dir $kill_trace_cmd
##echo_run $nohup_run $user@$vm1_ip $vm_working_dir "rsync -av /dev/shm/\*.log /dev/shm/\*.dat $log_base/$trace_log"
##echo_run $nohup_run $user@$host_ip $host_working_dir "rsync -av /dev/shm/\* $log_base/$trace_log"
#done
vm_period=1000
for a in 100 90 80 70 60 50 40 30 20 10
do
	vm_budget=$[ $vm_period * $a / 100 ]
	echo_run mkdir -p /home/lookflying/work/log/$trace_log_dir/$vm_period"_"$vm_budget
	echo_run ssh $user@$host_ip "set_deadline $vm1_pid $vm_period:$vm_budget"
	if [ $? -ne 0 ]
	then
		echo fail to set_deadline
		exit 1
	fi
	echo_run mkdir -p /home/lookflying/work/log/$trace_log_dir/$task_period
	echo_run $nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$trace_log_dir/$vm_period"_"$vm_budget 0 "int_freq.txt" $max_int_freq 20 
	echo_run $nohup_run $user@$host_ip $host_working_dir $notify_run $notify_info $log_to_dst $log_base/$trace_log_dir/$vm_period"_"$vm_budget 0 "host_sched.txt" $trace_sched $vm1_pid
	echo_run $notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $host_ip
#	echo_run $nohup_run $user@$host_ip $host_working_dir $kill_trace_cmd
#echo_run $nohup_run $user@$vm1_ip $vm_working_dir "rsync -av /dev/shm/\*.log /dev/shm/\*.dat $log_base/$trace_log"
#echo_run $nohup_run $user@$host_ip $host_working_dir "rsync -av /dev/shm/\* $log_base/$trace_log"
done

#for vm_period in 100000000 10000000 1000000 100000 10000 1000 100 10
#do
#	vm_budget=$[ $vm_period / 2 ]
#	echo_run mkdir -p /home/lookflying/work/log/$trace_log_dir/$vm_period"_"$vm_budget
#	echo_run ssh $user@$host_ip "set_deadline $vm1_pid $vm_period:$vm_budget"
#	if [ $? -ne 0 ]
#	then
#		echo fail to set_deadline
#		exit 1
#	fi
#	echo_run mkdir -p /home/lookflying/work/log/$trace_log_dir/$task_period
#	echo_run $nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$trace_log_dir/$vm_period"_"$vm_budget 0 "int_freq.txt" $max_int_freq 20 
#	echo_run $nohup_run $user@$host_ip $host_working_dir $notify_run $notify_info $log_to_dst $log_base/$trace_log_dir/$vm_period"_"$vm_budget 0 "host_sched.txt" $trace_sched $vm1_pid
#	echo_run $notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $host_ip
##	echo_run $nohup_run $user@$host_ip $host_working_dir $kill_trace_cmd
##echo_run $nohup_run $user@$vm1_ip $vm_working_dir "rsync -av /dev/shm/\*.log /dev/shm/\*.dat $log_base/$trace_log"
##echo_run $nohup_run $user@$host_ip $host_working_dir "rsync -av /dev/shm/\* $log_base/$trace_log"
#done

###single vm
###vm period=1000 us
#vm_period=1000
##for vm_utilization in 10 30 50 70 90 
#for vm_utilization in 100 90 80 70 60 50 40 30 20 10
##for vm_utilization in 60 50 40 30 20 10
##for vm_utilization in  70 90 
#do
#	vm_exec=$[ $vm_period * $vm_utilization / 100 ]
##echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$single_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm_period:$vm_exec -i $vm1_pid -s 10000000 -t 1 -u 0 -p 1000 -l $log_base/$single_vm_log_dir 
##echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip 
#echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$single_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm_period:$vm_exec -i $vm1_pid -s 100000000 -t 1 -u 50 -p 1000 -l $log_base/$single_vm_log_dir 
#echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip 
#done
#
##for vm_period in 100 1000 10000 100000 1000000 10000000 100000000 1000000000 10000000000 
#for vm_period in 100000000000
#for vm_period in 1 10 100 1000 10000 100000 1000000 
#do
#	vm_period=$[ 100000000 / $vm_period ]
#	vm_exec=$[ $vm_period / 4 ]
#echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$single_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm_period:$vm_exec -i $vm1_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$single_vm_log_dir 
#echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip 
##echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$single_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm_period:$vm_exec -i $vm1_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$single_vm_log_dir 
##echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip 
#done


# dual vm
vm2_pid=`ssh $user@$host_ip "cat /run/guest2.tid"`
if [ $? -ne 0 ]
then
	echo cannot get vm2 pid
	exit 1
fi

#for vm_period in 100 1000 10000 100000 1000000 10000000 100000000 1000000000 10000000000 100000000000
#for vm_period in 1 10 100 1000 10000 100000 1000000 10000000 100000000 
#for vm_period in 1 10 100 1000 10000 100000 1000000 10000000 100000000 
##for vm_period in 1000000000 10000000000 100000000000
#do
#	vm_period=$[ 100000000 / $vm_period ]
#	vm1_period=$vm_period
#	vm2_period=$vm_period
#	vm_exec=$vm_period
#	vm1_exec=$[ $vm_exec / 2 ]
#	vm2_exec=$[ $vm_exec / 2 ]
#	echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm1_period:$vm1_exec -i $vm1_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$nohup_run $user@$vm2_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm2_period:$vm2_exec -i $vm2_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $vm2_ip
#
#done

#for vm_period in 1000000 
##for vm_period in 1 10 100 1000 10000 100000 1000000 10000000 100000000 
##for vm_period in 1000000000 10000000000 100000000000
#do
#	vm_period=$[ 100000000 / $vm_period ]
#	vm1_period=$vm_period
#	vm2_period=$vm_period
#	vm_exec=$[ $vm_period / 2 ]
#	vm1_exec=$[ $vm_exec / 2 ]
#	vm2_exec=$[ $vm_exec / 2 ]
#	echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm1_period:$vm1_exec -i $vm1_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$nohup_run $user@$vm2_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm2_period:$vm2_exec -i $vm2_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $vm2_ip
#
#done

#vm1_period=1000
#vm2_period=1000
#g_util=""
#for ((i=92;i>=8;i-=4))
##for ((i=92;i>=72;i-=4))
#do
#	g_util=$i" "$g_util
#done
#echo $g_util
#for vm_utilization in $g_util
##for vm_utilization in 10 20 30 40 50 60 70 80 90
##for vm_utilization in 50
#do
#	vm_total_utilization=100
#	vm1_exec=$[ $vm_period * $vm_utilization * vm_total_utilization / 100 / 100 ]
#	vm2_exec=$[ $vm_period * (100 - $vm_utilization) * vm_total_utilization / 100 / 100 ]
#	echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm1_period:$vm1_exec -i $vm1_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$nohup_run $user@$vm2_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm2_period:$vm2_exec -i $vm2_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $vm2_ip
		
#	echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm1_period:$vm1_exec -i $vm1_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$nohup_run $user@$vm2_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm2_period:$vm2_exec -i $vm2_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $vm2_ip
#done

#for vm_utilization in 10 20 30 40 50 60 70 80 90
#do
#	vm_total_utilization=90
#	vm1_exec=$[ $vm_period * $vm_utilization * vm_total_utilization / 100 / 100 ]
#	vm2_exec=$[ $vm_period * (100 - $vm_utilization) * vm_total_utilization / 100 / 100 ]
#	echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm1_period:$vm1_exec -i $vm1_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$nohup_run $user@$vm2_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm2_period:$vm2_exec -i $vm2_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $vm2_ip
#		
#	echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm1_period:$vm1_exec -i $vm1_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$nohup_run $user@$vm2_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm2_period:$vm2_exec -i $vm2_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$dual_vm_log_dir 
#	echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $vm2_ip
#done
