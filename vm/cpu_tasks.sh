#!/bin/bash
if [ $# -eq 1 ]
then
	ps -eLo ruser,pid,ppid,lwp,psr,args | awk -v cpu_id=$1 '{if($5==cpu_id) print $0}'	
else
	echo "usage $0 <cpu-id>"
fi
