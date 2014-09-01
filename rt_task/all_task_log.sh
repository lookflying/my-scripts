#!/bin/bash
logname="run.log"
keys="miss_cnt= correct_thread_runtime= correct_cnt= thread_total= thread_run= latency"
while getopts :k: opt
do
	case $opt in
	k)
		echo key = $OPTARG
		keys=`echo $OPTARG|sed 'y/,/ /'`
		;;
	esac
done
shift $[ $OPTIND - 1 ]

if [ $# -ge 1 ]
then
	log_dirs=$@
	for dir in $log_dirs
	do
		if [ -d $dir ]
		then
			logs=`find $dir -name $logname|sort -V`
			if [ -n "$logs" ]
			then
				for log in $logs
				do
					vmname=${log%/$logname}
					vmname=${vmname%/*}
					vmname=${vmname##*/}
					vmname=${vmname%%/*}
					name=${log%/$logname}
					name=${name##*/}
	#if [ "$vmname" = "$name" ]
					if [ ! -n "$vmname" ]
					then
						name=`echo $name|sed 'y/_/ /'`
						echo -n -e  "$name\t"
					else
						name=`echo $name|sed 'y/_/ /'`
						vmpid=$vmname
						vmname=${vmname##*-}
						vmpid=${vmpid%$vmname}
						vmpid=${vmpid%-}
						vmpid=${vmpid##*-}
						vmname=`echo $vmname|sed 'y/_/ /'`
						vmbandwidth=`echo $vmname|awk '{print $2/$1*100"%"}'`
						if [ -n "$vmpid" ] && [ $vmpid -ne 0 ] && [ $vmpid -ne 1 ]
						then
							echo -n -e "$vmpid\t"
						fi
						echo -n -e "$vmname\t$vmbandwidth\t$name\t"
					fi
					for key in $keys
					do
						if [ $key = "latency" ] || [ $key = "Latency" ]
						then
							grep "Average wakeup latency" $log|awk '{printf $4"\t"}'
						else
							value=`cat $log|sed -n '/pid=/,$p'|grep $key`
							if [ $? -eq 0 ]
							then
								pvalue=`echo $value|awk '{$1="";print $0}'`
								echo -n -e "$pvalue\t"
								if [ -n "$vmbandwidth" ] && [ "${value/"thread_run="/}" != "$value" ]
								then
									taskload=`echo $value|awk -v vmbandwidth=$vmbandwidth '{print $5/vmbandwidth*100"%"}'`
									echo -n -e "$taskload\t"
								fi
							fi
						fi
					done
					echo -n -e "\n"
				done
			fi
		fi
	done
else
	echo "usage: $0 [-k <key1>,<key2>,...] <log_dir1> <log_dir2> ..."
fi
