#!/bin/bash

# Set Bash color
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
else
	echo -e $ECHO_PREFIX_ERROR "$username has no .Xauthority"
	exit 1
fi

