#!/bin/bash
cd /dev/cpuset
echo 1 > cpuset.cpu_exclusive
echo 0 > cpuset.sched_load_balance
#虚拟机cpuset，执行所有非VCPU操作
mkdir -p vm
echo 0 > vm/cpuset.cpus
echo 0 > vm/cpuset.mems
echo 1 > vm/cpuset.cpu_exclusive
echo 0 > vm/cpuset.mem_exclusive
#实时cpuset，运行VCPU
mkdir -p rt
echo 1 > rt/cpuset.cpus
echo 0 > rt/cpuset.mems 
echo 1 > rt/cpuset.cpu_exclusive
echo 0 > rt/cpuset.mem_exclusive
