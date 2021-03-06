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
trace=0
host=0
while getopts :u:g:d:s:p:a:x:bth: opt
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
	t)
		echo "enable ftrace"
		trace=1
		;;
	h)
		echo "host rt-app"
		host=1
		host_rt_arg=$OPTARG
		host_period=${host_rt_arg%:*}
		host_exec=${host_rt_arg#:*}
		;;
	esac
done

if [ -n "$guest" ] && [ -n "$step" ] && [ -n "$guest_script" ] && [ -n "$period" ] && [ -n "$arguments" ]
then
	ssh $user@$guest "mkdir -p $working_directory"/$testdir

	percentage=$step

	if [ $trace -eq 1 ]
	then
		mkdir -p $working_directory/$testdir
		testtime=`date +%Y%m%d%H%M%S`
		if [ $host -eq 1 ]
		then
			
			trace-cmd record -e "sched_switch" -e "sched_wakeup" -o $working_directory/$testdir/$testtime.dat rt-app -t $host_rt_arg -l $working_directory/$testdir/ -b $host_period"_"$host_exec"_"$testtime  & 
			traceid=$!
		else
			trace-cmd record -e "sched_switch" -e "sched_wakeup" -o $working_directory/$testdir/$testtime.dat & 
			traceid=$!
		fi
	fi
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
		testname=$period"_"$execution
		ssh $user@$guest "mkdir -p $working_directory/$testdir/$testname"
		rsync -av $guest_script $user@$guest:/$working_directory/$testdir/$testname
		sleep 4
		if [ $trace -eq 1 ]
		then
			ssh $user@$guest "cd $working_directory/$testdir/$testname; trace-cmd record -e \"sched_switch\" -e \"sched_wakeup\" -o $working_directory/$testdir/$testname/$testtime.dat $working_directory/$testdir/$testname/$guest_script $arguments"
		else
			ssh $user@$guest "$working_directory/$testdir/$testname/$guest_script $arguments"
		fi

		percentage=$[ $percentage + $step ]	
	done
	if [ $busy -eq 1 ]
	then
		killall stress
	fi
	if [ $host -eq 1 ]
	then
		killall rt-app
	fi
	if [ $trace -eq 1 ]
	then
		kill -2 $traceid
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
	echo -e "\t-h host run rt-app"
fi
