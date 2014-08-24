#!/bin/bash
logfile=/dev/shm/print_time_log
if [ $# -eq 1 ]
then
	threshold=$1
	if [ -f $logfile ]
	then
		cat $logfile|awk -v threshold=$threshold 'BEGIN{last=0}{if(last == 0){last=$3}delta=$3-last;if(delta > threshold){printf NR"\t"$3"\t"delta"\n"}last=$3}'|less 
	else
		echo $logfile does not exist.
		exit 1
	fi
fi
