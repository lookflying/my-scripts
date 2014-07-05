#!/bin/bash
logname="realtime"
function simple_title()
{
	echo -e "period\texec\tcount\tmiss\tmissrate"
}
function simple_miss_rate()
{
	if [ $# -eq 1 ]
	then
		file=$1
		name=`basename $file`
		name=${name%-.*}
		execution=${name##*_}
		period=${name#*_}
		period=${period%%_*}
		echo -n -e "$period\t$execution\t"
		cat $file|awk 'BEGIN{count=0;miss=0}{if($1==0){if($10<0){miss+=1}count+=1}}END{print count"\t"miss"\t"miss/count}'
	fi
}

if [ $# -eq 1 ]
then
	dir=$1
	simple_title
	for log in `find $dir -maxdepth 1 -type f -name $logname\\*.log|sort -V`
	do
		simple_miss_rate $log
	done
fi
