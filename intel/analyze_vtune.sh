#!/bin/bash
if [ -f $1/vtune* ]
then
	total_time=`grep "Elapsed Time" $1/vtune* |awk '{print $3}'`
	cpu_time=`grep "CPU Usage:" $1/vtune* |awk '{print $3}'`
	cpu_num=8
	usage=`echo "scale=10; $cpu_time / $cpu_num / $total_time * 100" | bc`
	usage_percentage=`echo "scale=2; $usage * 2 / 2"|bc`
	echo $usage_percentage%
fi
