#!/bin/bash
dir=${0%/*}
cmd=$dir/all_task_log.sh
arg="miss_cnt= correct_thread_runtime= correct_cnt= thread_total= thread_run= latency"
echo $cmd $@ $arg
$cmd $@ $arg
