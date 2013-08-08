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
function multi_task_dup_scripts(){
	ori_file=$1
	task=$2
	dup_dir=$3
	script_dir=$4
	duplicate_file $ori_file $task $dup_dir
	name=${ori_file##*/}
	name=${name%.*}
	suffix=${ori_file##*.}
	create_script $script_dir $name-$task-task.sh
	if [ $task -ne 1 ]
	then
		for file in $dup_files
		do
			add_to_script "convert -size $m_size -scale $t_size $file $${file%.*}-compressed.$suffix &"
		done
		add_to_script "wait"
	else
		for file in $dup_files
		do
			add_to_script "convert -size $m_size -scale $t_size $file $${file%.*}-compressed.$suffix"
		done
	fi
	finish_script
}
images=$1
shift
tasks=$@
dup_dir=/dev/shm/duplicated
#images=""
script_dir=/dev/shm/scripts
#for file in `ls *.jpeg`
#do
#	images=$file" "$images
#done
#for file in `ls *.jpg`
#do
#	images=$file" "$images
#done
echo $images
for image in $images
do
	reset_log
	set_log_column 21 
	print_log $image
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	print_log ""
	for task in $tasks
	do
		print_log $task
		multi_task_dup_scripts $image $task $dup_dir $script_dir 
		for ((j=1;j<=10;++j))
		do
			echo 3 > /proc/sys/vm/drop_caches
			cpu_usage_begin
			print_log `measure_time $new_script`
			cpu_usage_end
			print_log `cpu_usage`
		done
	done
	save_log $image-multi-task
done

