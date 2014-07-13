#!/bin/bash

testtime=`date +%Y%m%d%H%M%S`
testname=`basename $0`
testname=${testname%.*}
path=`dirname $0`
count=$[ `ls $path|grep $testname"_"|wc -l` + 1 ]
logpath=$path/$testname"_"$count"_"$testtime

realtime_script="$path/realtime.sh"
realtime="./realtime.sh"

busy=0
while getopts :b:h opt
do
	case $opt in
	b)
		echo "keep system busy(use stress)"
		busy=1
		;;
	h)
		echo "usage"
		echo -e "\t-h help"
		echo -e "\t-b keep system busy"
		;;
	esac
done

if [ $busy -eq 1 ]
then
	cpunum=`cat /proc/cpuinfo|grep processor|wc -l`
	stress --cpu $cpunum &
fi

cd $logpath
cp $realtime_script $logpath
$realtime -p 10000 -s 10 -d 20 -h
$realtime -p 20000 -s 10 -d 20 -h
$realtime -p 50000 -s 10 -d 20 -h
$realtime -p 100000 -s 10 -d 20 -h
$realtime -p 10000 -s 10 -d 20  
$realtime -p 20000 -s 10 -d 20  
$realtime -p 50000 -s 10 -d 20  
$realtime -p 100000 -s 10 -d 20  
cd -

if [ $busy -eq 1 ]
then
	killall stress
fi
wait


