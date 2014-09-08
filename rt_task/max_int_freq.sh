#!/bin/bash
int_freq=int_freq
if [ $# -eq 1 ]
then
	t=$1
	max_freq=0
	for ((i=0;i<$t;++i))
	do
		freq=`$int_freq|awk '{print $7}'`
		if [ $freq -gt $max_freq ]
		then
			max_freq=$freq
		fi
	done
	echo -n -e "max_int_freq=\t$max_freq\n"
else
	echo "usage: $0 <times>"
fi
