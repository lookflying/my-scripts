#!/bin/bash
testname=`date +%Y_%m_%d_%H_%M_%S`
path=`dirname $0`
mkdir $path/$testname
cd $path/$testname
trace-cmd record -e "sched_switch" $@

