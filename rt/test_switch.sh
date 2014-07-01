#!/bin/bash
testtime=`date +%Y%m%d%H%M%S`
testname=`basename $0`
testname=${testname%.*}
path=`dirname $0`
count=$[`ls $path|grep $testname"_"|wc -l` + 1]
logpath=$path/$testname"_"$count"_"$testtime
echo $count
PATH=$PATH:`pwd`
mkdir $logpath
trace-cmd start -e "sched_switch"
sleep 30
trace-cmd stop
trace-cmd extract -o $logpath/trace.dat
trace-cmd reset
