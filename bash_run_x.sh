#!/bin/bash
rundemo=~/MC/MediaCloud/rundemo.sh
mediaclouddemo=~/MC/MediaCloud/mediaclouddemo.sh
demolog=~/MC/MediaCloud/demo_log
vncviewer=~/MC/MediaCloud/vnc_auto.sh

#Set Bash color
ECHO_PREFIX_INFO="\033[1;32;40mINFO...\033[0;0m"
ECHO_PREFIX_ERROR="\033[1;31;40mError...\033[0;0m"
function try_command(){
	$@
	status=$?
	if [ $status -ne 0 ]
	then
		echo -e $ECHO_PREFIX_ERROR "Error with \"$@\", return status $status."
		exit $status
	fi
	return $status
}

if [ $# -ne 2 ]
then
	echo "usage: $0 first_id last_id"
	exit 1
else
	# This script must be run as root
	if [[ $EUID -ne 0 ]]; then
	    echo -e $ECHO_PREFIX_ERROR "This script must be run as root!" 1>&2
	    exit 1
	fi
	
	username=`who am i|awk '{print $1}'`
	xauthority="/home/$username/.Xauthority"
	if [ -f $xauthority ]
	then
		try_command cp $xauthority /root/
		export DISPLAY=:0.0
	else
		echo -e $ECHO_PREFIX_ERROR "$username has no .Xauthority"
		exit 1
	fi

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
fi

