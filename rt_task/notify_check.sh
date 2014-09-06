#!/bin/bash
loop=0
while getopts :p:l:a:u: opt
do
	case $opt in
	p)
		notify_path=$OPTARG
		;;
	l)
		loop=$OPTARG
		;;
	u)
		notify_user=$OPTARG
		;;
	a)
		notify_ip=$OPTARG
		;;
	esac
done
shift $[ $OPTIND - 1 ]

if [ $# -ge 1 ] && [ -n "$notify_user" ] && [ -n "$notify_ip" ] && [ -n "$notify_path" ]
then
	notify_keys=$@
	running=1
	begin=`date +%s`
	while [ $running -eq 1 ]
	do
		running=0
		for key in $notify_keys
		do
			state=`ssh $notify_user@$notify_ip "cat $notify_path/$key" 2>/dev/null` 
			if [ $? -ne 0 ]
			then
				running=1
				break;
			fi
			if [ $state -ne 0 ]
			then
				running=1
				break;
			fi
			continue
		done
		if [ $loop -ne 0 ]
		then
			sleep 1
			continue
		else
			break
		fi
	done
	for key in $notify_keys
	do
		ssh $notify_user@$notify_ip "rm $notify_path/$key"
	done
	if [ $loop -ne 0 ]
	then
		end=`date +%s`
		echo last $[ $end - $begin ] sec
	fi
	exit $running
else
	echo "usage: $0 -l loop -u <notify_user> -a <notify_ip> -p <notify_path>  <notify_key1> <notify_key2> ..."
fi
