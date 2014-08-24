#!/bin/bash
if [ $# -ge 2 ] && [ $# -le 3 ]
then
	cmd=$1
	pid=$2
	data=trace.dat
	if [ $# -eq 3 ]
	then
		data=$3
	fi
	if [ -f $data ]
	then
		trace-cmd report $data | grep $cmd":"$pid | awk '{print $3}' | awk 'BEGIN{FS=":";count=0}{if(NR%2){start=$1;}else{stop=$1;duration=stop-start;count+=1;print count"\t"start"\t"stop"\t"duration}}'
	fi
else
	echo "usage: $0 <cmd> <pid>"
fi
