#!/bin/bash
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 10000 -x realtime.sh -a "-p 10000 -s 10 -d 20 -h"  -b
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 20000 -x realtime.sh -a "-p 20000 -s 10 -d 20 -h"  -b
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 50000 -x realtime.sh -a "-p 50000 -s 10 -d 20 -h"  -b
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 100000 -x realtime.sh -a "-p 100000 -s 10 -d 20 -h"  -b
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 10000 -x realtime.sh -a "-p 10000 -s 10 -d 20  "  -b
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 20000 -x realtime.sh -a "-p 20000 -s 10 -d 20  "  -b
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 50000 -x realtime.sh -a "-p 50000 -s 10 -d 20  "  -b
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 100000 -x realtime.sh -a "-p 100000 -s 10 -d 20  "  -b
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 10000 -x realtime.sh -a "-p 20000 -s 10 -d 20" -b 
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 20000 -x realtime.sh -a "-p 40000 -s 10 -d 20" -b 
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 50000 -x realtime.sh -a "-p 100000 -s 10 -d 20" -b 
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 100000 -x realtime.sh -a "-p 200000 -s 10 -d 20" -b 
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 10000 -x realtime.sh -a "-p 10000 -s 10 -d 20"  
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 20000 -x realtime.sh -a "-p 20000 -s 10 -d 20"  
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 50000 -x realtime.sh -a "-p 50000 -s 10 -d 20"  
./vm_test.sh -g 192.168.1.69 -d /root/test -s 15 -p 100000 -x realtime.sh -a "-p 100000 -s 10 -d 20"  
