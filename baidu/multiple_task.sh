#!/bin/bash
if [ $# -eq 1 ]
then
	dir=$1
else
	dir=`pwd` 
fi

file=startrekintodarkness-h1080p_track1.h264
if [ -f $dir/$file ]
then
	./msdk_test.sh $dir/$file 1280 720 2000 &
	./msdk_test.sh $dir/$file 1280 720 3000 &
	./msdk_test.sh $dir/$file 1280 720 4000 &
	./msdk_test.sh $dir/$file 854 480 700 &
	./msdk_test.sh $dir/$file 854 480 1200 &
fi
file="113232_track1_1080p.h264"
if [ -f $dir/$file ]
then
	./msdk_test.sh $dir/$file 1280 720 2000 &
  ./msdk_test.sh $dir/$file 854 480 720 &
  ./msdk_test.sh $dir/$file 640 360 500 &
fi
file="manofsteel-tlr3_h720p_track1.h264"
if [ -f $dir/$file ]
then
  ./msdk_test.sh $dir/$file 640 480 600 &
  ./msdk_test.sh $dir/$file 640 360 500 &
fi
file=pacificrim-tlr1_h480p_track1.h264
if [ -f $dir/$file ]
then
  ./msdk_test.sh $dir/$file 640 360 500 &
fi

