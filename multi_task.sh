#!/bin/bash
source ./log_function.sh
source ./common_function.sh
function multi_task(){
	file=$1
	task=$2
	for ((i=1; i<=$task; ++i))
	do
		./test_compress.sh $file &
	done
	wait
}
tasks=$@
for file in `ls *.jpeg`
do
	reset_log
	set_log_column 3 
	for task in $tasks
	do
		echo 3 > /proc/sys/vm/drop_caches
		print_log $task
		cpu_usage_begin
		print_log `measure_time multi_task $file $task`
		cpu_usage_end
		print_log `cpu_usage`
	done
	save_log $file-multi-task
done

for file in `ls *.jpg`
do
	reset_log
	set_log_column 3
	for task in $tasks
	do
		echo 3 > /proc/sys/vm/drop_caches
		print_log $task
		cpu_usage_begin
		print_log `measure_time multi_task $file $task`
		cpu_usage_end
		print_log `cpu_usage`
	done
	save_log $file-multi-task
done
