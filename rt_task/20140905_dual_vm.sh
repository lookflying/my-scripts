#!/bin/bash
#for overhead
vm_ip1=192.168.1.45
#vm_ip1=192.168.1.3
vm_pid1=20746
vm_ip2=192.168.1.41
#vm_ip2=192.168.1.3
vm_pid2=21336
host_ip=192.168.1.22
notify_user=lookflying
notify_ip=192.168.1.3
notify_path=/dev/shm
run_date=20140905
empty=empty.list
tasklist=100000_50000_10000_5000_1000-50_50_1_0_1-0_50_5_0_1-20-0.list
for period in 100000 50000 20000 10000 5000 2000 1000
do
	for period2 in 100000 50000 20000 10000 5000 2000 1000
	do
		if [ $period -lt $period2 ]
		then
			continue
		fi
		execute=$[ $period / 2 ]
		execute2=$[ $period2 / 2 ]		
		
		##for task_load and miss_rate_raw
		./new_multiple_vm_run.sh $vm_ip1:$vm_pid1:$period:$execute:$host_ip,$vm_ip2:$vm_pid2:$period2:$execute2:$host_ip $notify_user,$notify_ip,$notify_path -f empty.list -l $notify_user@$notify_ip:/home/$notify_user/work/log/"$run_date"_dual_vm-$period"_"$execute-$period2"_"$execute2"-raw"
		./new_multiple_vm_run.sh $vm_ip1:$vm_pid1:$period:$execute:$host_ip,$vm_ip2:$vm_pid2:$period2:$execute2:$host_ip $notify_user,$notify_ip,$notify_path -f $tasklist -l $notify_user@$notify_ip:/home/$notify_user/work/log/"$run_date"_dual_vm-$period"_"$execute-$period2"_"$execute2"-raw"
	done
done
