#!/bin/bash
component_name=""
libdrm=libdrm-2.4.42.tar.gz
libva=libva-1.1.1.tar.gz
xf86=xf86-video-intel-2.21.4.tar.gz
intel_driver=intel-driver-1.0.20.tar.gz
function get_package_name(){
	if [ $# -eq 1 ]
	then
		dir=$1
		libdrm=`ls $dir|grep libdrm*.tar.gz|sort --version-sort|tail -1`
		libva=`ls $dir|grep libva*.tar.gz|sort --version-sort|tail -1`
		xf86=`ls $dir|grep xf86-video-intel*.tar.gz|sort --version-sort|tail -1`
		intel_driver=`ls $dir|grep intel-driver*.tar.gz|sort --version-sort|tail -1`
	fi
	echo $libdrm
	echo $libva
	echo $intel_driver
	echo $xf86
}
function change_component(){
	component_name=$1
}
function check_command(){
#usage $0 command info [good value]
	good_value=0
	command_info=$1
	if [ $# -ge 2 ]
	then
		command_info=$2
	fi
	if [ $# -eq 3 ]
	then
		good_value=$3	
	fi
	$1 >& /dev/null
	result=$?
	if [ $result -ne $good_value ]
	then
		$1 >& /dev/null #retry only once
		result=$?
		if [ $result -ne $good_value ]
		then
			echo "$command_info fail"
			exit $result
		fi 
	fi
	echo "$command_info succeed"
}

function check_last_command(){
	result=$?
	good_value=0
	command_info=`history|tail -2|head -1`
	if [ $# -ge 1 ]
	then
		command_info=$1
	fi
	if [ $# -ge 2 ]
	then
		good_value=$2
	fi
	if [ $result -ne $good_value ]
	then
		echo "line $command_info fail"
		exit $result
	fi
	echo "line $command_info pass"
}
function get_dir_name(){
	dir=$1
	dir=${dir%.*}
	dir=${dir%.*}
	echo $dir
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

echo "this script will install the drivers for media cloud"
get_package_name .

change_component "libdrm"
tar xzf $libdrm
check_last_command $LINENO
cd `get_dir_name $libdrm` 
#./autogen.sh -prefix=/usr
#check_command "./autogen.sh -prefix=/usr" "autogen.sh of $component_name" 0
#check_command "./configure" "configure $component_name" 0
auto_configure
check_command "make -j9" "make $component_name" 0
check_command "make install" "install $component_name" 0

cd ..



change_component "xf86-video-intel"
tar xzf $xf86 
check_last_command $LINENO
cd `get_dir_name $xf86`
#check_command "./autogen.sh -prefix=/usr" "autogen.sh of $component_name" 0
#check_command "./configure" "configure $component_name" 0
auto_configure
check_command "make -j9" "make $component_name" 0
check_command "make install" "install $component_name" 0
cd ..

change_component "libva"
tar xzf $libva
check_last_command $LINENO
cd `get_dir_name $libva`
#check_command "./autogen.sh -prefix=/usr/local" "autogen.sh of $component_name" 0
#check_command "./configure" "configure $component_name" 0
auto_configure
check_command "make -j9" "make $component_name" 0
check_command "make install" "install $component_name" 0
cd ..

change_component "intel-driver-staging"
tar xzf $intel_driver
check_last_command $LINENO
cd `get_dir_name $intel_driver`
#check_command "./autogen.sh -prefix=/usr/local" "autogen.sh of $component_name" 0
#check_command "./configure" "configure $component_name" 0
auto_configure
check_command "make -j9" "make $component_name" 0
check_command "make install" "install $component_name" 0
cd ..


echo "install_step2.sh fininshed!"
echo "please run install_step3.sh"
