#!/bin/bash
function analyze_log
{
	file=$1
	file_name=${file##*/}
	video=`echo $file_name|awk 'BEGIN{FS="_"}{print $3"_"$4"_"$5"_"$6}'`
	encoder=`echo ${file_name%%.*}|awk 'BEGIN{FS="_"}{print $7}'`
#	echo $file_name
#	echo $video
#	echo $encoder

	case $encoder in
	"x264")
		bitrate=`cat $file|grep -e "encoded.*frames"|awk '{print $6}'`
		size=`cat $file|grep "test.264"|awk '{print $1}'`
		used_time=`cat $file|grep "real"|awk 'BEGIN{FS=" |\t|\n|m|s"}{print $2*60+$3}'`
		echo -e $video"\t""x264""\t""\t"$bitrate"\t"$size"\t"$used_time
	;;
	"hevc")
		bitrate=`cat $file|grep "Bytes written to file"|awk 'BEGIN{FS=" |\t|\n|\\\\("}{print $7}'`
		size=`cat $file|grep "Bytes written to file"|awk 'BEGIN{FS=" |\t|\n|\\\\("}{print $5}'`
		used_time=`cat $file|grep "Total Time"|awk '{print $3}'`
		cfg=`echo $file|awk 'BEGIN{FS="hevc_|\\\\."}{print $2}'`
		echo -e $video"\t""hevc""\t"$cfg"\t"$bitrate"\t"$size"\t"$used_time
	;;
	esac
}
if [ $# -eq 1 ] && [ -d $1 ]
then
	for log_file in $1/*.log
	do
#		echo $log_file
		analyze_log $log_file
	done
else
	echo usage: $0 log_dir
fi
