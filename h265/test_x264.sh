#!/bin/bash
if [ -e test.264 ]
then
	rm -rf test.264
fi

if [ $# -eq 5 ] && [ -f $1 ]
then
	time x264 -o test.264 --profile high --level 3.1 --fps $4 --frames $5 --threads 1 --bitrate 1000 $1 --input-res $2"x"$3
elif [ $# -eq 6 ] && [ -f $1 ] 
then
	time x264 -o test.264 --profile high --level 3.1 --fps $4 --frames $5 --threads 1 --bitrate $6 $1 --input-res $2"x"$3
elif [ $# -eq 1 ] && [ -f $1 ]
then
	time x264 -o test.264 --profile high --level 3.1 --fps 25 --frames 60 --threads 1 --bitrate 1000 $1 --input-res 1920x1080
else
	time x264 -o test.264 --profile high --level 3.1 --fps 25 --frames 60 --threads 1 --bitrate 1000 ./1080_blue_sky.yuv --input-res 1920x1080
fi

if [ -f test.264 ]
then
	du -b test.264
fi
