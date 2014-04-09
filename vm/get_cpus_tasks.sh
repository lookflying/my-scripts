#!/bin/bash
dir="$( cd "$( dirname "$0")" && pwd )"
get_cpu_tasks="$dir/get_cpu_tasks.sh"
if [ $# -ge 1 ]
then
	for cpu in $@
	do
		echo -n -e $cpu:`$get_cpu_tasks $cpu`"\t"
	done
	echo
else
	echo "usage: $0 <cpu-id0> <cpu-id1> ..."
fi
