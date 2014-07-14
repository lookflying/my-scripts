#!/bin/bash
ip=10.42.0.35
##1
#./vm_test.sh -g $ip -d /root/test -s 15 -p 10000 -x realtime.sh -a "-p 10000 -s 10 -d 60 -h"  -b
#./vm_test.sh -g $ip -d /root/test -s 15 -p 20000 -x realtime.sh -a "-p 20000 -s 10 -d 60 -h"  -b
#./vm_test.sh -g $ip -d /root/test -s 15 -p 50000 -x realtime.sh -a "-p 50000 -s 10 -d 60 -h"  -b
#./vm_test.sh -g $ip -d /root/test -s 15 -p 100000 -x realtime.sh -a "-p 100000 -s 10 -d 60 -h"  -b
#2
./vm_test.sh -g $ip -d /root/test -s 15 -p 10000 -x realtime.sh -a "-p 10000 -s 10 -d 60  "  -b
./vm_test.sh -g $ip -d /root/test -s 15 -p 20000 -x realtime.sh -a "-p 20000 -s 10 -d 60  "  -b
./vm_test.sh -g $ip -d /root/test -s 15 -p 50000 -x realtime.sh -a "-p 50000 -s 10 -d 60  "  -b
./vm_test.sh -g $ip -d /root/test -s 15 -p 100000 -x realtime.sh -a "-p 100000 -s 10 -d 60  "  -b
#3
./vm_test.sh -g $ip -d /root/test -s 15 -p 10000 -x realtime.sh -a "-p 20000 -s 10 -d 60" -b 
./vm_test.sh -g $ip -d /root/test -s 15 -p 20000 -x realtime.sh -a "-p 40000 -s 10 -d 60" -b 
./vm_test.sh -g $ip -d /root/test -s 15 -p 50000 -x realtime.sh -a "-p 100000 -s 10 -d 60" -b 
./vm_test.sh -g $ip -d /root/test -s 15 -p 100000 -x realtime.sh -a "-p 200000 -s 10 -d 60" -b 
##4
#./vm_test.sh -g $ip -d /root/test -s 15 -p 10000 -x realtime.sh -a "-p 10000 -s 10 -d 60"  
#./vm_test.sh -g $ip -d /root/test -s 15 -p 20000 -x realtime.sh -a "-p 20000 -s 10 -d 60"  
#./vm_test.sh -g $ip -d /root/test -s 15 -p 50000 -x realtime.sh -a "-p 50000 -s 10 -d 60"  
#./vm_test.sh -g $ip -d /root/test -s 15 -p 100000 -x realtime.sh -a "-p 100000 -s 10 -d 60"  
