#!/bin/bash


#get file size in bytes
function get_file_size(){
    file=$1
    echo `ls -l $file|awk '{print $5}'`
}

function measure_time(){
    TIMEFORMAT=%R
    exec 3>&1 4>&2
    { time $@ 1>&3 2>&4; } 2>&1 | awk '{print $NF}'
    exec 3>&- 4>&-
}

function cpu_usage_begin(){
	cpu_begin=`head -n 1 /proc/stat`
}
function cpu_usage_end(){
	cpu_end=`head -n 1 /proc/stat`
}
function cpu_work_load(){
	work_load=`expr $2 + $3 + $4`
	echo $work_load
}
function cpu_total_load(){
	total_load=`expr $2 + $3 + $4 + $5 + $6 + $7 + $8`
	echo $total_load
}
function cpu_usage(){
	begin_work_load=`cpu_work_load $cpu_begin`
	begin_total_load=`cpu_total_load $cpu_begin`
	end_work_load=`cpu_work_load $cpu_end`
	end_total_load=`cpu_total_load $cpu_end`
	echo "100 * ($end_work_load - $begin_work_load) / ($end_total_load - $begin_total_load)"|bc
}
