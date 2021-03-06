#!/bin/bash
if [ $# -eq 8 ] && [ -f $1 ] && [ -f $2 ]
then
	cfg=${1##*/}
	filename="$8_${cfg%.*}"
	bitrate=`expr $7 \* 1000`
	echo $7
	time /home/projects/h265/HM-11.0/bin/TAppEncoderStatic -c $1 -i $2 -wdt $3 -hgt $4 -fr $5 -f $6 --RateControl --TargetBitrate=$bitrate --BitstreamFile=$filename".bin" --ReconFile=$filename".yuv"
elif [ $# -eq 7 ] && [ -f $1 ] && [ -f $2 ]
then
	bitrate=`expr $7 \* 1000`
	echo $7
	time /home/projects/h265/HM-11.0/bin/TAppEncoderStatic -c $1 --Profile=main --Level=6.2 -i $2 -wdt $3 -hgt $4 -fr $5 -f $6 --RateControl --TargetBitrate=$bitrate
elif [ $# -eq 6 ] && [ -f $1 ] && [ -f $2 ]
then
	time /home/projects/h265/HM-11.0/bin/TAppEncoderStatic -c $1 --Profile=main --Level=6.2 -i $2 -wdt $3 -hgt $4 -fr $5 -f $6 --RateControl --TargetBitrate=1000000
else
	echo usage: $0 cfg yuv width height fps frames "[bitrate] [filename]"
fi
