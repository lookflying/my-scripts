#!/bin/bash
dir="$( cd "$( dirname "$0")" && pwd )"
function get_cpu_tasks(){
	ps -eLo psr|grep $1|wc -l
}
if [ $# -ge 1 ]
then
	for cpu in $@
	do
		echo -n -e $cpu:`get_cpu_tasks $cpu`"\t"
	done
	echo
else
	echo "usage: $0 <cpu-id0> <cpu-id1> ..."
fi
