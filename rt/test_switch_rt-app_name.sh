#!/bin/bash
testname=$1
path=`dirname $0`
logdir=$path/$testname
mkdir $logdir
cd $logdir
shift
trace-cmd record -e "sched_switch" rt-app -l $logdir $@

