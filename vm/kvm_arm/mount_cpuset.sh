#!/bin/bash
mkdir /dev/cpuset
mount -t cgroup -o cpuset cpuset /dev/cpuset
cd /dev/cpuset

