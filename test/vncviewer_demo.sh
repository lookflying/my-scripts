#!/bin/bash
if [ $# -ne 3 ]
then
	echo "usage: $0 address first_id last_id"
	exit 1
else
	for (( i=$2; i<=$3; i++))
	do
		gvncviewer $1:$i &
	done
fi
