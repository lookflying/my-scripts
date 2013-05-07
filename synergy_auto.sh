#!/bin/bash
if [ $# -eq 1 ]
then
	killall synergyc
	sleep 1
	synergyc $1
else
	echo "usage: $0 synergy-server"
fi
