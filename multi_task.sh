#!/bin/bash
source ./log_function.sh
source ./common_function.sh
function naive_convert(){
	convert $1 -resize 50% $2
}
function naive_multi_task_dup(){
	for file in $dup_files
	do
		naive_convert $file $file$$ &
	done
	wait
}
function multi_task_dup(){
	for file in $dup_files
	do
		./test_compress.sh $file &
	done
	wait
}
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
dup_dir=/dev/shm/duplicated
images=""
for file in `ls *.jpeg`
do
	images=$file" "$images
done
for file in `ls *.jpg`
do
	images=$file" "$images
done
for file in $images
do
	reset_log
	set_log_column 3 
	print_log $file
	print_log ""
	print_log ""
	for task in $tasks
	do
#		echo 3 > /proc/sys/vm/drop_caches
		duplicate_file $file $task $dup_dir 
		print_log $task
#		echo 3 > /proc/sys/vm/drop_caches
		cpu_usage_begin
#print_log `measure_time multi_task $file $task`
#		print_log `measure_time multi_task_dup`
		print_log `measure_time naive_multi_task_dup`
		cpu_usage_end
		print_log `cpu_usage`
	done
	save_log $file-multi-task
done

#for file in `ls *.jpg`
#do
#	reset_log
#	set_log_column 3
#	for task in $tasks
#	do
#		echo 3 > /proc/sys/vm/drop_caches
#		print_log $task
#		cpu_usage_begin
#		print_log `measure_time multi_task $file $task`
#		cpu_usage_end
#		print_log `cpu_usage`
#	done
#	save_log $file-multi-task
#done
