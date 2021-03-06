#!/bin/bash
if [ $# -eq 1 ] && [ -f $1 ]
then
	time /home/projects/h265/openHEVC/build/wrapper_hm/HM/TAppEncoder -c $1 --Profile=main --Level=3.1 -i /home/projects/h265/1080_blue_sky.yuv -wdt 1920 -hgt 1080 -fr 25 -f 60 --RateControl --TargetBitrate=1000
elif [ $# -eq 2 ] && [ -f $1 ] && [ -f $2 ]
then
	time /home/projects/h265/openHEVC/build/wrapper_hm/HM/TAppEncoder -c $1 --Profile=main --Level=3.1 -i $2 -wdt 1920 -hgt 1080 -fr 25 -f 60 --RateControl --TargetBitrate=1000
else
	time /home/projects/h265/openHEVC/build/wrapper_hm/HM/TAppEncoder -c /home/projects/h265/cfg/encoder_intra_main.cfg --Profile=main --Level=3.1 -i /home/projects/h265/1080_blue_sky.yuv -wdt 1920 -hgt 1080 -fr 25 -f 60 --RateControl --TargetBitrate=1000
fi
