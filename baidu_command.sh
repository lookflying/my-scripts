#!/bin/bash

function test_threads(){
	if [ $# -eq 4 ] && [ -x ./test_baidu.sh ]
	then
		file=$1
		resolution=$2
		bitrate=$3
		maxthreads=$4
		for ((i=1; i<=$maxthreads; i++))
		do
			filename=${file##*/}
			outputfile=${filename%%.h264}"_"$resolution"_"$bitrate".h264"
			logfile=${filename%%.h264}"_"$resolution"_"$bitrate"_"$i"threads.log"
			./test_baidu.sh $file $i $outputfile $resolution $bitrate 2>&1 |tee $logfile
		done
	fi
}



if [ $# -eq 1 ]
then
	dir=$1
	file=startrekintodarkness-h1080p_track1.h264
	if [ -f $dir/$file ]
	then
		test_threads $dir/$file 1280x720 2000k 50
		test_threads $dir/$file 1280x720 3000k 50
		test_threads $dir/$file 1280x720 4000k 50
		test_threads $dir/$file 854x480 700k 50
		test_threads $dir/$file 854x480 1200k 50
	fi
	file="113232_track1_1080p.h264"
	if [ -f $dir/$file ]
	then
		test_threads $dir/$file 1280x720 2000k 50
		test_threads $dir/$file 854x480 720k 50
		test_threads $dir/$file 640x360 500k 50
	fi
	file=manofsteel-tlr3_h720p_track1.h264
	if [ -f $dir/$file ]
	then
		test_threads $dir/$file 640x480 600k 50
		test_threads $dir/$file 640x360 500k 50
	fi
	file=pacificrim-tlr1_h480p_track1.h264
	if [ -f $dir/$file ]
	then
		test_threads $dir/$file 640x360 500k 50
	fi
else
	echo usage: $0 dir
fi
