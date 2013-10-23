#!/bin/bash
if [ $# -eq 1 ]
then
	dir=$1
	for logfile in `ls $dir|grep \\\\.log|sort -V`
	do
		./show_log.sh $dir/$logfile
	done
fi
