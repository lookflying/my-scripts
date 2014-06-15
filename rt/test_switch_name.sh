#!/bin/bash
testname=$1
path=`dirname $0`
mkdir $path/$testname
cd $path/$testname
shift
trace-cmd record -e "sched_switch" $@

