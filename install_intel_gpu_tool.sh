#!/bin/bash
intel_gpu_tools=intel-gpu-tools-1.3.tar.gz

function get_package_name(){
	if [ $# -eq 1 ]
	then
		dir=$1
#	libdrm=`ls $dir|grep libdrm*.tar.gz|sort --version-sort|tail -1`
#	libva=`ls $dir|grep libva*.tar.gz|sort --version-sort|tail -1`
#	xf86=`ls $dir|grep xf86-video-intel*.tar.gz|sort --version-sort|tail -1`
#	intel_driver=`ls $dir|grep intel-driver*.tar.gz|sort --version-sort|tail -1`
		intel_gpu_tools=`ls $dir|grep intel-gpu-tools-*.tar.gz|sort --version-sort|tail -1`
	fi
#echo $libdrm
#echo $libva
#echo $intel_driver
#echo $xf86
	echo $intel_gpu_tools
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

function auto_configure(){
	if [ -f ./autogen.sh ]
	then
		try_command  "./autogen.sh" "autogen.sh of $component_name" 0
	elif [ -f ./configure ]
	then
		try_command "./configure" "configure $component_name" 0
	else
		echo "no autogen.sh or configure"
		exit 1
	fi
}

echo "this script will install intel-gpu-tools"
# This script must be run as root
if [[ $EUID -ne 0 ]]; then
    echo -e $ECHO_PREFIX_ERROR "This script must be run as root!" 1>&2
    exit 1
fi
get_package_name .
#try_command apt-get update
try_command apt-get install libcairo2-dev -y
try_command tar xzf $intel_gpu_tools
try_command cd `get_dir_name $intel_gpu_tools`
try_command ./autogen.sh 
try_command make -j9
try_command make install

