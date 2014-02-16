#!/bin/bash
source `dirname $0`/common_function.sh
script=`dirname $0`/msdk_test.sh
log_script=`dirname $0`/show_log.sh
function run(){
	if [ $# -eq 2 ]
		then
		file=$1
		count=$2
		for ((i=1; i<=$count; ++i))
		do
			$script $file 1920 1080 4000 &
		done
		wait
	fi
}

function run_log(){
	file=$1
	count=$2
	t=`measure_time run $file $count`
	frames=`$log_script|awk 'BEGIN{sum=0}{sum+=$4}END{print sum}'`
	fps=`awk -v frames=$frames -v t=$t 'BEGIN{print frames/t}'`
	echo -e $t"\t"$fps
	rm -f *.log
}

function dir_run(){
	if [ $# -eq 3 ]
	then
		dir=$1
		begin=$2
		end=$3
		for video in $1/*.h264
		do
			for ((i=$begin; i<=$end; ++i))
			do
				echo -n -e `basename $video`"\t"$i"\t"
				run_log $video $i
			done
		done
	fi
}
rm -f *.log
result_file=`date +%Y%m%d_%H%M%S`_result
dir_run $@ |tee $result_file
