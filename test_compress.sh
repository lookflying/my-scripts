#!/bin/bash
dir=compressed
if [ ! -d $dir ]
then
	rm -rf $dir
	mkdir $dir
fi
file=$1
name=${file##*/}
name=${name%%.*}
suffix=${file##*.}
convert $file -resize 50% $dir/$name-$$.$suffix

