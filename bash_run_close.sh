#!/bin/bash
rundemo=~/MC/MediaCloud/rundemo.sh
mediaclouddemo=~/MC/MediaCloud/mediaclouddemo.sh
demolog=~/MC/MediaCloud/demo_log
vncviewer=~/MC/MediaCloud/vnc_auto.sh
stopvncviewer=~/MC/MediaCloud/stop_vnc.sh
if [ $# -ne 2 ]
then
	echo "usage: $0 first_id last_id"
	exit 1
else
	sudo echo "you have root privilege"
	if [ $? = 0 ]
	then
		sysctl -w net.core.wmem_max=1048576
		sysctl -w net.core.rmem_max=1048576
		sudo rm -rf $demolog
		mkdir $demolog
		if [ $? -ne 0 ]
		then
			echo "fail to create demo_log"
			exit 1
		fi
		chmod 777 $demolog
		for (( i=$1; i<=$2; i++))
		do
			echo "run demo $i"
			$rundemo $i >& $demolog/rundemo$i.log &
			$mediaclouddemo $i >& $demolog/mediaclouddemo$i.log &
			$vncviewer localhost $i $i &
		done
		for (( i=0; i<=20; i++))
		do
			sleep 1
		done
		echo stop vnc_viewer
		$stopvncviewer
	else
		echo "no root privilege"
		exit 1
	fi
fi
