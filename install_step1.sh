#!/bin/bash
function get_package_name(){
	if [ $# -eq 1 ]
	then
		dir=$1
		libdrm=`ls $dir|grep libdrm`
		libva=`ls $dir|grep libva`
		xf86=`ls $dir|grep xf86-video-intel`
		intel_driver=`ls $dir|grep intel-driver`
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
echo "this script will install some necessary packages for the media cloud"
change_component "apt-get"
apt-get update >& /dev/null
check_last_command $LINENO
apt-get install chromium-browser -y >& /dev/null
check_last_command $LINENO
apt-get install autoconf automake libtool -y >& /dev/null
apt-get install libpthread-stubs0-dev -y >& /dev/null
apt-get install libpciaccess-dev -y >& /dev/null
check_last_command $LINENO
apt-get install xutils-dev -y >& /dev/null
apt-get install xserver-xorg-dev -y >& /dev/null
check_last_command $LINENO
apt-get install g++ -y >& /dev/null
apt-get install libxext-dev -y >& /dev/null
apt-get install libxfixes-dev -y >& /dev/null
check_last_command $LINENO

apt-get install vainfo -y >& /dev/null
check_last_command $LINENO
apt-get install gvncviewer -y >& /dev/null 
check_last_command $LINENO
apt-get install openssh-server -y >& /dev/null
check_last_command $LINENO
apt-get install libgl1-mesa-dev -y >& /dev/null
check_last_command $LINENO

change_component "l_ipp_em64t_p_6.1.6.063"
tar xzf l_ipp_em64t_p_6.1.6.063.tar.gz 
check_last_command $LINENO
cd l_ipp_em64t_p_6.1.6.063/
./install.sh 
check_last_command "install $component_name"
cd ..
cp ipp.conf /etc/ld.so.conf.d
check_last_command "install $component_name"
ldconfig
check_last_command "install $component_name"

echo install_step1.sh finished, please run install_step2.sh
