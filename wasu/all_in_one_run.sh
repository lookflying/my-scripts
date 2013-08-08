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


bashrun=~/MC/MediaCloud/bash_run.sh
demolog=~/MC/MediaCloud/demo_log
report_root_dir=~/intel/amplxe/projects/
amplxe="/opt/intel/vtune_amplifier_xe_2013/bin64/amplxe-cl"
stopall=~/MC/MediaCloud/stop.sh
running_time=240
sample_time=10
gpu_top="intel_gpu_top"

function run_amplxe(){
	if [ $# -eq 3 ]
	then
		description=$1
		id=$2
		sample_time=$3
		reportdir=$report_root_dir$description	
		rundate=`date +%Y%m%d`
		echo $sample_time
		$amplxe -collect snb-bandwidth --duration $sample_time -user-data-dir=$reportdir -r $rundate-$description-$i
	else
		echo wrong
	fi
}
function save_log(){
	if [ $# -ge 3 ]
	then
		description=$1
		id=$2
		logdir=$3	
		rundate=`date +%Y%m%d`
		if [ $# -ge 4 ]
		then
			extra_file=$4
			tar zcvf $rundate-$description-$id.tar.gz $logdir $extra_file
		else
			tar zcvf $rundate-$description-$id.tar.gz $logdir
		fi
	fi
}
function create_dir(){
	if [ $# -eq 1 ]
	then
		dir=$1
		ext=`date +%Y%m%d%H%M%S`
		if [ -e $dir ]
		then
			mkdir -p $dir$ext
		else
			mkdir -p $dir
		fi

	fi
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
	export DISPLAY=:0.0
else
	echo -e $ECHO_PREFIX_ERROR "$username has no .Xauthority"
	exit 1
fi
echo 0 >/proc/sys/kernel/nmi_watchdog
if [ $# -lt 3 -o $# -gt 5 ]
then
	echo "usage: $0 min max description [running time] [sample time] "
else
	min=$1
	max=$2
#	description=$3
#	create_dir $report_root_dir/$description
	if [ $# -ge 4 ]
	then
		running_time=$4
	fi
	if [ $# -ge 5 ]
	then
		sample_time=$5
	else
		sample_time=10
	fi
	for (( i=$min; i<=$max; i++))
	do
		echo "running $i"
		$bashrun 1 $i &
#		if [ -e "/root/MC/MediaCloud/gpu_top.log" ]
#		then
#			rm -rf "/root/MC/MediaCloud/gpu_top.log"
#		fi
#		$gpu_top -o /root/MC/MediaCloud/gpu_top.log >& /dev/null &
		for (( j=0; j<=$running_time; j++))
		do
			echo -en "\r$j seconds"
			sleep 1
		done
#		run_amplxe $description $i $sample_time|tee >& $demolog/vtune$i.log 
		$stopall
		$stopall
#		mv "/root/MC/MediaCloud/gpu_top.log" $demolog/
		save_log $description $i $demolog 
	done
		
fi
exit 0
