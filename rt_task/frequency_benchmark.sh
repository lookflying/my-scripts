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
for key in $host_ip $vm1_pid $vm2_pid
do
	rm -rf $notify_path/$key
done
$prepare_log $log_base $host_log_dir
$prepare_log $log_base $single_vm_log_dir
$prepare_log $log_base $dual_vm_log_dir

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
#single vm
#vm period=1000 us
vm_period=1000
#for vm_utilization in 10 30 50 70 90 
#for vm_utilization in  70 90 
#do
#	vm_exec=$[ $vm_period * $vm_utilization / 100 ]
#echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$single_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm_period:$vm_exec -i $vm1_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$single_vm_log_dir 
#echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip 
#echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$single_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm_period:$vm_exec -i $vm1_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$single_vm_log_dir 
#echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip 
#done
#
##for vm_period in 100 1000 10000 100000 1000000 10000000 100000000 1000000000 10000000000 
#for vm_period in 100000000000
#do
#	vm_exec=$[ $vm_period / 2 ]
#echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$single_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm_period:$vm_exec -i $vm1_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$single_vm_log_dir 
#echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip 
#echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$single_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm_period:$vm_exec -i $vm1_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$single_vm_log_dir 
#echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip 
#done


# dual vm
vm2_pid=`ssh $user@$host_ip "cat /run/guest2.tid"`
if [ $? -ne 0 ]
then
	echo cannot get vm2 pid
	exit 1
fi

#for vm_period in 100 1000 10000 100000 1000000 10000000 100000000 1000000000 10000000000 100000000000
#for vm_period in 1000000000 10000000000 100000000000
#do
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


vm1_period=1000
vm2_period=1000
for vm_utilization in 10 20 30 40 50 60 70 80 90
#for vm_utilization in 50
do
	vm_total_utilization=50
	vm1_exec=$[ $vm_period * $vm_utilization * vm_total_utilization / 100 / 100 ]
	vm2_exec=$[ $vm_period * (100 - $vm_utilization) * vm_total_utilization / 100 / 100 ]
	echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm1_period:$vm1_exec -i $vm1_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
	echo_run	$nohup_run $user@$vm2_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm2_period:$vm2_exec -i $vm2_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
	echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $vm2_ip
		
	echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm1_period:$vm1_exec -i $vm1_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$dual_vm_log_dir 
	echo_run	$nohup_run $user@$vm2_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm2_period:$vm2_exec -i $vm2_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$dual_vm_log_dir 
	echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $vm2_ip
done

for vm_utilization in 10 20 30 40 50 60 70 80 90
do
	vm_total_utilization=90
	vm1_exec=$[ $vm_period * $vm_utilization * vm_total_utilization / 100 / 100 ]
	vm2_exec=$[ $vm_period * (100 - $vm_utilization) * vm_total_utilization / 100 / 100 ]
	echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm1_period:$vm1_exec -i $vm1_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
	echo_run	$nohup_run $user@$vm2_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm2_period:$vm2_exec -i $vm2_pid -s 1000000000 -t 1 -u 0 -p 1000 -l $log_base/$dual_vm_log_dir 
	echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $vm2_ip
		
	echo_run	$nohup_run $user@$vm1_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm1_period:$vm1_exec -i $vm1_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$dual_vm_log_dir 
	echo_run	$nohup_run $user@$vm2_ip $vm_working_dir $notify_run $notify_info $log_to_dst $log_base/$dual_vm_log_dir 2 $single_vm_frequency -h $host_ip -v $vm2_period:$vm2_exec -i $vm2_pid -s 1000000000 -t 1 -u 50 -p 1000 -l $log_base/$dual_vm_log_dir 
	echo_run	$notify_check -u $notify_user -a $notify_ip -p $notify_path -l 1 $vm1_ip $vm2_ip
done
