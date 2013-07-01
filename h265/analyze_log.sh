#!/bin/bash
function analyze_log
{
	file=$1
	file_name=${file##*/}
	video=`echo $file_name|awk 'BEGIN{FS="_"}{print $3"_"$4"_"$5"_"$6}'`
	encoder=`echo ${file_name%%.*}|awk 'BEGIN{FS="_"}{print $7}'`

	echo $file_name
	echo $video
	echo $encoder
}
if [ $# -eq 1 ] && [ -d $1 ]
then
	for log_file in $1/*.log
	do
		echo $log_file
		analyze_log $log_file
	done
else
	echo usage: $0 log_dir
fi
