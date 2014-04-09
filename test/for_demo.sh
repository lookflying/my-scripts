#!/bin/bash
if [ $# -ne 2 ]
then
echo "usage $0 first_id last_id"
exit 1
else
	for (( i=$1; i<=$2; i++)) 
	do
		echo $i
	done
	exit 0
fi
