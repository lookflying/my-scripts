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

function duplicate_file(){
	if [ $# -eq 3 ]
	then
		file=$1
		n=$2
		dir=$3
		name=${file##*/}	
		name=${name%%.*}
		suffix=${file##*.}
		dup_files=""
		if [ ! -d $dir ]
		then
			rm -rf $dir
			mkdir $dir
		fi
		for ((i=1; i<=$n; ++i))
		do
			new_file=$dir/$name-$i.$suffix
			if [ ! -f $new_file ]
			then
				cp $file $new_file
			fi
			dup_files=$new_file" "$dup_files
		done
			sync
	fi
}

function create_script(){
	script_dir=$1
	script_file=$2
	if [ ! -d $script_dir ]
	then
		rm -rf $script_dir
		mkdir -p $script_dir
	fi
	new_script=$script_dir/$script_file
	echo '#!/bin/bash' > $new_script
}

function add_to_script(){
	if [ -f $new_scripts ]
	then
		echo "$@" >> $new_script
	fi
}

function finish_script(){
	chmod a+x $new_script
}
