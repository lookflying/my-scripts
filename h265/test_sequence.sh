#!/bin/bash
set -x
function test_log
{
	#sample test_log ./test_x264 abc.yuv x264 logdir abc.cfg
	if [ $# -ge 4 ] && [ -x $1 ]
	then
		if [ -f $5 ]
		then
			logfile=`./get_parameters.sh $2 $3 $5`
			parameters=$5" "`./get_parameters.sh $2`
		else
			logfile=`./get_parameters.sh $2 $3`
			parameters=`./get_parameters.sh $2`
		fi
		if [ -d $4 ]
		then
			$1 $parameters >& $4/$logfile
		else
			$1 $parameters >& $logfile
		fi
	fi
}

function test_sequence
{
	if [ $# -eq 3 ]
	then
		test_log ./test_x264.sh $1 x264 $3
		for cfg in $2/*.cfg
		do
			test_log ./test_hevc.sh $1 hevc $3 $cfg
		done
	fi
}
if [ $# -eq 3 ] && [ -d $1 ]
then
	for seq in $1/*.yuv
	do
		test_sequence $seq $2 $3
	done
elif [ $# -eq 3 ] && [ -f $1 ]
then
	test_sequence $@
else
	echo usage: $0 sequencefile cfgdir logdir
	echo usage: $0 sequencedir cfgdir logdir
fi

