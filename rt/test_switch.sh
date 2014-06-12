#!/bin/bash
testname=`date +%Y_%m_%d_%H_%M_%S`
mkdir $testname
cd $testname
trace-cmd record -e "sched_switch" $@

