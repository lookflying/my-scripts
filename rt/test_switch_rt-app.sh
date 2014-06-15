#!/bin/bash
testname=`date +%Y_%m_%d_%H_%M_%S`
path=`dirname $0`
logdir=$path/$testname
mkdir $logdir
cd $logdir
trace-cmd record -e "sched_switch" rt-app -l $logdir $@

