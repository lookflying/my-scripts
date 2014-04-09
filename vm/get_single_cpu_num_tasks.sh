#!/bin/bash
if [ $# -eq 1 ]
then
	ps -eLo psr|grep $1|wc -l
else
	echo usage: $0 cpu_id
fi
