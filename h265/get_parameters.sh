#!/bin/bash
if [ $# -ge 1 ] && [ -f $1 ]
then
	size=`du $1 -b|awk '{print $1}'`
	name=${1##*/}
	name=${name%.*}
	resolution=`echo $name|awk 'BEGIN{FS="_"}{print $2}'`
	fps=`echo $name|awk 'BEGIN{FS="_"}{print $3}'`
	case $resolution in
	"720p")
		width=1280
		height=720
		;;
	"1080p")
		width=1920
		height=1080
		;;
	*)
		width=`echo $name|awk 'BEGIN{FS="_"}{print $2}'|awk 'BEGIN{FS="x"}{print $1}'`
		height=`echo $name|awk 'BEGIN{FS="_"}{print $2}'|awk 'BEGIN{FS="x"}{print $2}'`
		;;
	esac
	frame_size=`expr $width \* $height \* 3 / 2`
	frame_count=`expr $size / $frame_size`
#use The kush Gauge
#Frame width * frame height * frame rate * motion rate (1,2 or 4) * constant (0.07)/1,000 = target bit rate in kilobits per second (kbps)
	motion_rate=4
	#bitrate in kbps
	bitrate=`echo "$width * $height * $fps * $motion_rate * 0.07 / 1000" | bc`
	if [ $# -eq 1 ]
	then
		echo "$1 $width $height $fps $frame_count $bitrate $name"
	elif [ $# -eq 2 ]
	then
		runtime=`date +%Y%m%d_%H%M%S`
		echo $runtime"_"$name"_"$frame_count"_"$2".log"
	elif [ $# -eq 3 ]
	then
		runtime=`date +%Y%m%d_%H%M%S`
		cfg=${3##*/}
		cfg=${cfg%.*}
		echo $runtime"_"$name"_"$frame_count"_"$2"_"$cfg".log"
	fi
fi
