#!/bin/bash
vtune=vtune_amplifier_xe_2013_update5.tar.gz

function get_package_name(){
	if [ $# -eq 1 ]
	then
		dir=$1
		vtune=`ls $dir|grep vtune_amplifier_xe_*.tar.gz|sort --version-sort|tail -1`
	fi
	echo $vtune
}

function auto_configure(){
	if [ -f ./autogen.sh ]
	then
		check_command "./autogen.sh -prefix=/usr" "autogen.sh of $component_name" 0
	elif [ -f ./configure ]
	then
		check_command "./configure" "configure $component_name" 0
	else
		echo "no autogen.sh or configure"
		exit 1
	fi
}


function get_dir_name(){
	dir=$1
	dir=${dir%.*}
	dir=${dir%.*}
	echo $dir
}

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


echo "this script will install vtune"
# This script must be run as root
if [[ $EUID -ne 0 ]]; then
    echo -e $ECHO_PREFIX_ERROR "This script must be run as root!" 1>&2
    exit 1
fi
get_package_name .
tar xzf $vtune
cd `get_dir_name $vtune`
./install.sh
