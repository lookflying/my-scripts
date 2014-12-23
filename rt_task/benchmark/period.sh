#!/bin/bash
./trend.sh 10000000:10000000 30|tee /dev/shm/period_1000.log
./trend.sh 8000000:8000000 30|tee /dev/shm/period_800.log
./trend.sh 4000000:4000000 30|tee /dev/shm/period_500.log
./trend.sh 2000000:2000000 30|tee /dev/shm/period_200.log
./trend.sh 1000000:1000000 30|tee /dev/shm/period_100.log
./trend.sh 500000:500000 30|tee /dev/shm/period_50.log
./trend.sh 250000:250000 30|tee /dev/shm/period_25.log
cp /dev/shm/period_*.log .
