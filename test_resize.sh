#!/bin/bash
dir=/dev/shm/compressed
if [ ! -d $dir ]
then
	rm -rf $dir
	mkdir $dir
fi
file=$1
name=${file##*/}
name=${name%%.*}
suffix=${file##*.}
m_size=`./size_helper.sh $file m`
t_size=`./size_helper.sh $file t`
convert -size $m_size -scale $t_size $file $dir/$name-$$.$suffix

