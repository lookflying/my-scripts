#!/bin/bash
testname=`date +%Y_%m_%d_%H_%M_%S`
path=`basename $0`
mkdir $pathi/$testname
cd $path/$testname
trace-cmd record -e "sched_switch" $@

