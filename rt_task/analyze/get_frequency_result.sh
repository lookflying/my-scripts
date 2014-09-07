#!/bin/bash
if [ $# -eq 1 ]
then
	log_dir=$1
	log_files=`find $log_dir -maxdepth 1 -type f -name \*.txt`
	echo -n -e "vm period\tvm exec\tvm utilization\ttask utilization\tprecision\tperiod\tfreq\n"
	for file in $log_files
	do
		period=`tail -1 $file|awk '{print $2}'`
		name=${file%.txt}
		name=${name##*/}
		freq=`echo $period|awk '{print 1000000000 / $1}'`
		precision=`echo $name|awk 'BEGIN{FS="-"}{print $5}'`
		task_utilization=`echo $name|awk 'BEGIN{FS="-"}{print $6}'`
		vm_period=`echo $name|awk 'BEGIN{FS="-|_"}{if(NF >= 11)print $10}'`
		vm_exec=`echo $name|awk 'BEGIN{FS="-|_"}{if(NF >= 11)print $11}'`
		vm_utilization=`echo "$vm_period $vm_exec"|awk '{if(NF==2)print $2/$1*100}'`
		echo -n -e "${vm_period:-nan}\t"
		echo -n -e "${vm_exec:-nan}\t"
		echo -n -e "${vm_utilization:-nan}\t"
		echo -n -e "${task_utilization:-nan}\t"
		echo -n -e "${precision:-nan}\t"
		echo -n -e "${period:-nan}\t"
		echo -n -e "${freq:-nan}\n"

	done
else
	echo "usage: $0 <log_dir>"
fi
