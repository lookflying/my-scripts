#!/bin/bash
cd /dev/cpuset
mkdir -p vm
echo 1 > vm/cpuset.cpus
echo 0 > vm/cpuset.mems
echo 1 > cpuset.cpu_exclusive
echo 0 > cpuset.sched_load_balance
echo 1 > vm/cpuset.cpu_exclusive
echo 1 > vm/cpuset.mem_exclusive

