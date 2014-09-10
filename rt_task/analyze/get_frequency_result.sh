#!/bin/bash
if [ $# -eq 1 ]
then
	log_dir=$1
	log_files=`find $log_dir -maxdepth 1 -type f -name \*.txt`
	echo -n -e "vm period\tvm exec\tvm utilization\ttask utilization\tmiss ratio threshold\tperiod\tfreq\tip\tmtime\n"
	for file in $log_files
	do
		period=`tail -1 $file|awk '{print $2}'`
		name=${file%.txt}
		name=${name##*/}
		freq=`echo $period|awk '{print 1000000000 / $1}'`
		threshold=`echo $name|awk 'BEGIN{FS="-"}{print $5}'`
		task_utilization=`echo $name|awk 'BEGIN{FS="-"}{print $6}'`
		vm_period=`echo $name|awk 'BEGIN{FS="-|_"}{if(NF >= 11)print $10}'`
		vm_exec=`echo $name|awk 'BEGIN{FS="-|_"}{if(NF >= 11)print $11}'`
		vm_utilization=`echo "$vm_period $vm_exec"|awk '{if(NF==2)print $2/$1*100}'`
		ip=`echo $name|awk 'BEGIN{FS="-"}{print $7}'`
		mtime=`stat -c %Y $file`
		if [ -z "$vm_utilization" ] || [ -z "$task_utilization" ] || [ -z "$threshold" ] || [ -z "$period" ]
		then
			echo $file
			continue
		fi
		echo -n -e "${vm_period:-nan}\t"
		echo -n -e "${vm_exec:-nan}\t"
		echo -n -e "${vm_utilization:-nan}\t"
		echo -n -e "${task_utilization:-nan}\t"
		echo -n -e "${threshold:-nan}\t"
		echo -n -e "${period:-nan}\t"
		echo -n -e "${freq:-nan}\t"
		echo -n -e "${ip:-nan}\t"
		echo -n -e "${mtime:-nan}\n"
	done
else
	echo "usage: $0 <log_dir>"
fi
