#!/bin/bash
taskscript=./run_rt_task.sh
runlog="run.log"
function usage()
{
		echo "usage:"
		echo -e "\t"-f"\t"task list file
		echo -e "\t"-l"\t"log destination
		echo -e "\t"-c"\t"comment, will be append to log dir
		exit 0
}

function run_task()
{
	period=$1
	budget=$2
	execute=$3
	duration=$4
	log=$5
	dst=$6
	taskname=$period"_"$budget"_"$execute"_"$duration
	$taskscript -p$period -b$budget -e$execute -d$duration -l$log |tee /dev/shm/$runlog
	rsync /dev/shm/*.log /dev/shm/*.dat $dst/$taskname
	if [ $? -ne 0 ]
	then
		echo fail to rsync to $dst/$taskname @ `date +"%Y-%m-%d %H:%M:%S"`
	fi
}
if [ $# -eq 0 ]
then
	usage
fi
while getopts :f:l:c: opt
do
	case $opt in
	f)
		echo task list file = $OPTARG
		listfiles=$listfiles" "$OPTARG
		;;
	l)
		echo log destination = $OPTARG
		logdst=$OPTARG
		;;
	c)
		echo comment = $OPTARG
		comment=$OPTARG
		;;
	esac
done
for listfile in $listfiles
do
	if [ -n "$listfile" ] && [ -n "$logdst" ]
	then
		list=${listfile%.*}
		batchname=`date +%Y%m%d_%H%M%S_`$list
		if [ -n "$comment" ]
		then
			batchname=$batchname"-"$comment
		fi
		if [ ! -f $listfile ]
		then
			echo $listfile does not exist.
			exit 1
		fi
		mkdir $batchname &>/dev/null
		if [ $? -ne 0 ]
		then
			echo fail to mkdir $batchname
			exit 1
		fi
		echo dir = $batchname
		rsync -av $batchname $logdst &>/dev/null
		if [ $? -ne 0 ]
		then
			echo can not access $logdst
			exit 1
		fi
		rm -r $batchname
		sed -n '/^#/!p' $listfile|sed -n '/^$/!p'| \
		while read line
		do
			run_task $line $logdst/$batchname
		done
	else
		usage
	fi
done
