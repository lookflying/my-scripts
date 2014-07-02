#!/bin/bash
working_directory="/root/test/"
executing=0
pull=0
clean=0
host_dir="host"
guest_dir="guest"
while getopts :u:h:g:s:d:xp:c: opt
do
	case $opt in
	u) 
		echo user="$OPTARG"
		user=$OPTARG
		;;
	h)
		echo host="$OPTARG"
		host=$OPTARG
		;;
	g)
		echo guest="$OPTARG"
		guest=$OPTARG
		;;
	s)
		echo script="$OPTARG"
		script=$OPTARG
		;;
	d)
		echo working_directory="$OPTARG"
		working_directory=$OPTARG
		;;
	x)
		echo "exectuing"
		executing=1
		;;
	p)
		echo "pull out the result"
		pull=1
		log_script=$OPTARG
		log_script=${log_script%.*}
		;;
	c)
		echo "clean the logs"
		clean=1
		log_to_clean=$OPTARG
		log_to_clean=${log_to_clean%.*}
		;;
	esac
done

shift $[ $OPTIND - 1 ]

count=1
for param in $@
do
	echo "parameter $count: $param"
	count=$[ $count + 1 ]
	
done

if [ -n "$user" ] && [ -n "$host" ] && [ -n "$guest" ]
then
	echo "start working"	
	ssh $user@$host "mkdir -p $working_directory"
	ssh $user@$guest "mkdir -p $working_directory"
	if [ $pull -eq 0 ] && [ -n "$script" ]
	then
		rsync -av $script $user@$host:$working_directory
		rsync -av $script $user@$guest:$working_directory
			if [ $executing -eq 1 ]
		then
			ssh $user@$host "$working_directory/$script" &
			ssh $user@$guest "$working_directory/$script" &
			wait
		fi
elif [ $pull -eq 1 ]
	then
		mkdir -p $host_dir
		mkdir -p $guest_dir
		rsync -av $user@$host:$working_directory/$log_script"_*" $host_dir
		rsync -av $user@$guest:$working_directory/$log_script"_*" $guest_dir
	fi
	if [ $clean -eq 1 ]
	then
		ssh $user@$host "find $working_directory -maxdepth 1 -type d -name $log_script\\* -exec rm -r {} \\;"	
		ssh $user@$guest "find $working_directory -maxdepth 1 -type d -name $log_script\\* -exec rm -r {} \\;"	
	fi
else
	echo "usage:"
	echo -e "\t-u user(both host and guest)"
	echo -e "\t-h host ip"
	echo -e "\t-g guest ip"
	echo -e "\t-s script file"
	echo -e "\t-d working directory"
	echo -e "\t-x execute the script"
	echo -e "\t-p pull the logs of specified script"
	echo -e "\t-c clean the logs of specified script"
fi
