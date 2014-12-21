#!/bin/bash
./trend.sh 10000000:5000000 30|tee /dev/shm/guest_100.log
./trend.sh 5000000:2500000 30|tee /dev/shm/guest_50.log
./trend.sh 1000000:500000 30|tee /dev/shm/guest_10.log
cp /dev/shm/guest_*.log .
