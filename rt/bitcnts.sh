#!/bin/bash

testtime=`date +%Y%m%d%H%M%S`
testname=`basename $0`
testname=${testname%.*}
path=`dirname $0`
count=$[ `ls $path|grep $testname"_"|wc -l` + 1 ]
logpath=$path/$testname"_"$count"_"$testtime

iteration=100000000
if [ $# -eq 1 ]
then
	iteration=$1
fi
mkdir -p $logpath
bitcnts $iteration > $logpath/$testname"_"$iteration".log"

