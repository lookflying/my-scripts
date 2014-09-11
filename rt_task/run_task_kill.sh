#!/bin/bash
./run_rt_task_nano.sh $@
ssh root@192.168.1.22 "/root/mnt/my-scripts/rt_task/kill_trace_cmd.sh"
