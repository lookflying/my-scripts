#!/bin/bash
if [ $# -eq 1 ]
then
	log=$1
	task=${log##*/}
	task=${task#*_}
	task=${task%%_*}
	num=${log##*/}
	num=${num##*_}
	num=${num%%.log}
	content=
	frame=`cat $log|grep "frame="`
	frame=${frame##*frame= }
	frame=${frame%% fps*}
	#echo $frame
	psnr=`cat $log|grep average:`
	psnr_y=`echo $psnr|awk '{print $2}'`
	psnr_u=`echo $psnr|awk '{print $3}'`
	psnr_v=`echo $psnr|awk '{print $4}'`
#	echo $psnr_y $psnr_u $psnr_v
	latency=`cat $log|grep real|awk '{print $2}'`
	min=${latency%%m*}
	sec=${latency#*m}
	sec=${sec%s}
#	echo $latency
#	echo $min
#	echo $sec
	encoding_time=`echo "scale=3; $sec + 60 * $min" | bc`
	#echo $encoding_time
	fps=`echo "scale=4; $frame / $encoding_time" | bc `
	#echo $fps
	echo -e "$task\t$num\t$frame\t$encoding_time\t$fps\t$psnr_y\t$psnr_u\t$psnr_y"
fi
