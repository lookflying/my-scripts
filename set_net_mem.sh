#!/bin/bash
if [ $# -eq 2 -o $# -eq 1 ]
then
	if [ $# -eq 2 ]
	then
		sysctl -w net.core.rmem_max=$1
		sysctl -w net.core.rmem_default=$1
		sysctl -w net.core.wmem_max=$2
		sysctl -w net.core.wmem_default=$2
		exit 0
	fi
	if [ $# -eq 1 ]
	then
		sysctl -w net.core.rmem_max=$1
		sysctl -w net.core.rmem_default=$1
		sysctl -w net.core.wmem_max=$1
		sysctl -w net.core.wmem_default=$1
		exit 0
	fi
else
	echo "usage: $0 read_size write_size or $0 same_size"
	exit 1
fi
