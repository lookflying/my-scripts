#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "/proc/sys/net/ipv4/ip_forward = " `cat /proc/sys/net/ipv4/ip_forward`
