#!/bin/bash
if [ $# -eq 1 ]
then
	dir=$1
else
	dir=.
fi
for log in `ls $dir/*.log`
do
	file=${log##*/}
	file=${file%.log}
	name=${file%_*}
	name=${name%_*}
	option=${file#$name"_"}
	latency=`cat $log | grep "Common transcoding time"|awk '{print $5}'`
	frames=`cat $log | grep "Number of processed frames"|awk '{print $5}'`
	echo -e $name"\t"$option"\t"$latency"\t"$frames
done
