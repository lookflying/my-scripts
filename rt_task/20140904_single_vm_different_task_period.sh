#!/bin/bash
vm_pid=6711
host_ip=192.168.1.22
batch_run=${0%/*}/vm_batch_run_rt_task.sh
for period in 10000 9000 8000 7000 6000 5000 4000 3000 2000 1000
do
	execute=$[ $period / 2 ]
	$batch_run $vm_pid $host_ip $period:$execute -f 10000_5000_1000-50_50_1_0_1-0_0_1_0_1-20-0.list -l lookflying@192.168.1.3:/home/lookflying/work/log/20140904_single_vm_different_vm_period_overhead_raw
	$batch_run $vm_pid $host_ip $period:$execute -f 10000_5000_1000-50_50_1_0_1-10_50_1_0_1-20-0.list -l lookflying@192.168.1.3:/home/lookflying/work/log/20140904_single_vm_different_vm_period_miss_rate_raw
done

