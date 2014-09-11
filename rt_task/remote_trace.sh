#!/bin/bash
trace_dir=/dev/shm/host_trace
cd /dev/shm
mkdir -p $trace_dir
cd $trace_dir
trace-cmd record -e 'sched_wakeup*' -e sched_switch -e 'sched_migrate*'

