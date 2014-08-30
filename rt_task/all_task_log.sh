#!/bin/bash
logname="run.log"
keys="miss_cnt= correct_thread_runtime= correct_cnt= thread_total= thread_run= latency"
if [ $# -ge 1 ]
then
	dir=$1
	if [ -d $dir ]
	then
		if [ $# -ge 2 ]
		then
			shift
			keys=$@
		fi
		logs=`find $dir -name $logname|sort -V`
		if [ -n "$logs" ]
		then
			for log in $logs
			do
				vmname=${log#*/}
				vmname=${vmname%%/*}
				name=${log%/$logname}
				name=${name##*/}
				if [ "$vmname" = "$name" ]
				then
					name=`echo $name|sed 'y/_/ /'`
					echo -n -e  "$name\t"
				else
					name=`echo $name|sed 'y/_/ /'`
					vmname=${vmname##*-}
					vmname=`echo $vmname|sed 'y/_/ /'`
					vmbandwidth=`echo $vmname|awk '{print $2/$1*100"%"}'`
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
else
	echo "usage: $0 log_dir <field1> <field2> ..."
fi
