#!/bin/bash
logname="run.log"
keys="miss_cnt"
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
				name=`echo $name|sed 'y/_/ /'`
				if [ "$vmname" = "$name" ]
				then
					echo -n -e  "$name\t"
				else
					vmname=${vmname##*-}
					vmname=`echo $vmname|sed 'y/_/ /'`
					echo -n -e "$vmname\t$name\t"
				fi
				for key in $keys
				do
					value=`cat $log|sed -n '/pid=/,$p'|grep $key`
					if [ $? -eq 0 ]
					then
						pvalue=`echo $value|awk '{$1="";print $0}'`
						echo -n -e "$pvalue\t"
					fi
				done
				echo -n -e "\n"
			done
		fi
	fi
fi
