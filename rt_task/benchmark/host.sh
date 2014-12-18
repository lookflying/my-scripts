#!/bin/bash
./trend.sh 10000000:5000000 30|tee /dev/shm/host_100.log
./trend.sh 8000000:4000000 30|tee /dev/shm/host_80.log
./trend.sh 5000000:2500000 30|tee /dev/shm/host_50.log
./trend.sh 4000000:2000000 30|tee /dev/shm/host_40.log
./trend.sh 2000000:1000000 30|tee /dev/shm/host_20.log
./trend.sh 1000000:500000 30|tee /dev/shm/host_10.log
