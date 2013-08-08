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

echo "this script will install google-chrome"
# This script must be run as root
if [[ $EUID -ne 0 ]]; then
    echo -e $ECHO_PREFIX_ERROR "This script must be run as root!" 1>&2
    exit 1
fi
try_command wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
try_command sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
try_command apt-get update
try_command apt-get install google-chrome-stable
