#!/bin/bash
target_dir=encoded
if [ ! -d $target_dir ]
then
	rm -rf $target_dir
	mkdir -p $target_dir
fi
export LD_LIBRARY_PATH=/opt/intel/mediasdk/bin/x64
transcode=/opt/intel/mediasdk/samples/__cmake/intel64.make.release/__bin/release/sample_multi_transcode_drm
file=$1
width=$2
height=$3
bitrate=$4
name=${file##*/}
name=${name%.h264}
log_file=$name"_"$width"x"$height"_"$bitrate"k"_$$.log
$transcode -i::h264 $file -o::h264 $target_dir/$name"_"$width"x"$height"_"$bitrate"k".h264 -b $bitrate -w $width -h $height -hw -f 30 &> $log_file
