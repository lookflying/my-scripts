#!/bin/bash
testtime=`date +%Y%m%d%H%M%S`
testname=`basename $0`
testname=${testname%.*}
path=`dirname $0`
count=$[`ls $path|grep $testname"_"|wc -l` + 1]
logpath=$testname"_"$count"_"$testtime
echo $count
PATH=$PATH:`pwd`
mkdir $path/$logpath
cd $path/$logpath
trace-cmd record -e "sched_switch" $@
