#!/bin/bash
working_directory="/root/test/"
while getopts :u:h:g:s:d: opt
do
	case $opt in
	u) 
		echo user="$OPTARG"
		user=$OPTARG;;
	h)
		echo host="$OPTARG"
		host=$OPTARG;;
	g)
		echo guest="$OPTARG"
		guest=$OPTARG;;
	s)
		echo script="$OPTARG"
		script=$OPTARG;;
	d)
		echo working_directory="$OPTARG"
		working_directory=$OPTARG;;
	esac
done

shift $[ $OPTIND - 1 ]

count=1
for param in $@
do
	echo "parameter $count: $param"
	count=$[ $count + 1 ]
	
done

if [ -n "$user" ] && [ -n "$host" ] && [ -n "$guest" ] && [ -n "$script" ]
then
	echo "start working"
	ssh $user@$host "mkdir -p $working_directory"
	ssh $user@$guest "mkdir -p $working_directory"
	rsync -av $script $user@$host:$working_directory
	rsync -av $script $user@$guest:$working_directory
fi
