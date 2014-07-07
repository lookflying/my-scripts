#!/bin/bash
working_directory="/root/test/"
executing=0
pull=0
clean=0
host_dir="host"
guest_dir="guest"
latest_dir="latest"
function set_latest()
{
	if [ $# -eq 1 ]
	then
		mkdir -p $latest_dir
		name=$1
		wd=`pwd`
		test -n "$host" && latest_host=`find $wd/$host_dir -maxdepth 1 -name $name\*|sort -V|tail -1`
		test -n "$guest" && latest_guest=`find $wd/$guest_dir -maxdepth 1 -name $name\*|sort -V|tail -1`
		test -n "$host" && rm -f  $latest_dir/$name"_host_latest" 
		test -n "$guest" && rm -f $latest_dir/$name"_guest_latest"
		test -n "$host" && ln -s $latest_host $latest_dir/$name"_host_latest"
		test -n "$guest" && ln -s $latest_guest $latest_dir/$name"_guest_latest"
	fi
}
while getopts :u:h:g:s:d:xp:c:a:r: opt
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
	a)
		echo "script arguments"
		arguments=$OPTARG
		echo "arguments = $arguments"
		;;
	r)
		echo "get result dir $OPTARG"
		result=$OPTARG	
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
if [ -n "$user" ] 
then
	echo "start working"	
	test -n "$host" && ssh $user@$host "mkdir -p $working_directory"
	test -n "$guest" &&	ssh $user@$guest "mkdir -p $working_directory"
	if [ -n "$script" ]
	then
		test -n "$host" && rsync -av $script $user@$host:$working_directory
		test -n "$guest" && rsync -av $script $user@$guest:$working_directory
		if [ $executing -eq 1 ]
		then
			test -n "$host" && ssh $user@$host "$working_directory/$script $arguments" &
			test -n "$guest" && ssh $user@$guest "$working_directory/$script $arguments" &
			wait
		fi
	fi
	if [ $pull -eq 1 ]
	then
		test -n "$host" && mkdir -p $host_dir
		test -n "$guest" && mkdir -p $guest_dir
		test -n "$host" && rsync -av $user@$host:$working_directory/$log_script"_*" $host_dir
		test -n "$guest" && rsync -av $user@$guest:$working_directory/$log_script"_*" $guest_dir
		set_latest $log_script
	fi
	if [ $clean -eq 1 ]
	then
		test -n "$host" && echo "cleaning logs on $host"
		test -n "$host" && ssh $user@$host "find $working_directory -maxdepth 1 -type d -name $log_to_clean\\* -exec echo {} \; -exec rm -r {} \\;"	
		test -n "$guest" && echo "cleaning logs on $guest"
		test -n "$guest" && ssh $user@$guest "find $working_directory -maxdepth 1 -type d -name $log_to_clean\\* -exec echo {} \; -exec rm -r {} \\;"	
	fi
	if [ -n "$result" ]
	then
		if [ -n "$guest" ]
		then
			rsync -av $user@$guest:/$working_directory/$result/ $result
		elif [ -n "$host" ]
		then
			rsync -av $user@$host:/$working_directory/$result/ $result
		fi
	fi
else
	echo "usage:"
	echo -e "\t-u\tuser(both host and guest)"
	echo -e "\t-h\thost ip"
	echo -e "\t-g\tguest ip"
	echo -e "\t-s\tscript file"
	echo -e "\t-d\tworking directory"
	echo -e "\t-x\texecute the script"
	echo -e "\t-p\tpull the logs of specified script"
	echo -e "\t-c\tclean the logs of specified script"
	echo -e "\t-a\targuments to the script"
	echo -e "\t-r\tget specified result dir,"
	echo -e "\t\tif guest is provided, then get from guest, otherwise from host"
fi
