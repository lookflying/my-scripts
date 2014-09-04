#!/bin/bash
batch_run=${0%/*}/batch_run_rt_task.sh
$batch_run -f empty.list -l lookflying@192.168.1.3:/home/lookflying/work/log/20140904_host_different_task_period_overhead_raw
$batch_run -f 10000_9000_8000_7000_6000_5000_4000_3000_2000_1000-50_50_1_0_1-0_0_1_0_1-20-0.list -l lookflying@192.168.1.3:/home/lookflying/work/log/20140904_host_different_task_period_overhead_raw
$batch_run -f empty.list -l lookflying@192.168.1.3:/home/lookflying/work/log/20140904_host_different_task_period_miss_rate_raw
$batch_run -f 10000_9000_8000_7000_6000_5000_4000_3000_2000_1000-50_50_1_0_1-10_50_1_0_1-20-0.list -l lookflying@192.168.1.3:/home/lookflying/work/log/20140904_host_different_task_period_miss_rate_raw


