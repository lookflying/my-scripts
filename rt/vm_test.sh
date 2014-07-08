#!/bin/bash
qemu_tid_file="/run/qemu.tid"
function get_qemu_tid()
{
	if [ -f $qemu_tid_file ]
	then
		cat $qemu_tid_file
	else
		echo 0
	fi	
}
working_directory=`pwd`
testdir="vm"
user=$USER
busy=0

while getopts :u:g:d:s:p:a:x:b opt
do
	case $opt in
	g)
		echo guest="$OPTARG"
		guest=$OPTARG
		;;
	d)
		echo working_directory="$OPTARG"
		working_directory=$OPTARG
		;;
	s)
		echo step="$OPTARG"%
		step=$OPTARG
		;;
	x)
		echo guest_script="$OPTARG"
		guest_script=$OPTARG
		;;
	p)
		echo period="$OPTARG"
		period=$OPTARG
		;;
	a)
		echo arguments="$OPTARG"
		arguments=$OPTARG
		;;
	u)
		echo user="$OPTARG"
		user=$OPTARG
		;;
	b)
		echo "keep host busy(stress)"
		busy=1
		;;
	esac
done

if [ -n "$guest" ] && [ -n "$step" ] && [ -n "$guest_script" ] && [ -n "$period" ] && [ -n "$arguments" ]
then
	ssh $user@$guest "mkdir -p $working_directory"/$testdir

	percentage=$step
	if [ $busy -eq 1 ]
	then
		cpunum=`cat /proc/cpuinfo|grep processor|wc -l`
		stress --cpu $cpunum &
	fi
	while [ $percentage -lt 100 ]
	do
		execution=`expr $period \* $percentage / 100`
		echo "vm deadline $period:$execution"
		set_deadline `get_qemu_tid` $period:$execution
		sleep 3
		testname=$period"_"$execution
		ssh $user@$guest "mkdir -p $working_directory/$testdir/$testname"
		rsync -av $guest_script $user@$guest:/$working_directory/$testdir/$testname
		ssh $user@$guest "$working_directory/$testdir/$testname/$guest_script $arguments"

		percentage=$[ $percentage + $step ]	
	done
	if [ $busy -eq 1 ]
	then
		killall stress
	fi
	wait
else
	echo "usage"
	echo -e "\t-g guest ip"
	echo -e "\t-d working directory, default pwd"
	echo -e "\t-s step(in percentage)"
	echo -e "\t-x guest script to execute"
	echo -e "\t-p period(in microsecond)"
	echo -e "\t-a guest script arguments"
	echo -e "\t-u user"
	echo -e "\t-b keep host busy"
fi
