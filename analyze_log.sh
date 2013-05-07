#!/bin/bash
function analyze()
{
	echo "Encoding time:"
	echo -ne "\tcount:\t"
	grep Encoding $1/*|wc -l
	echo -ne "\tmaximum:\t"
	grep Encoding $1/*|awk '{print $6}'|sort -n|tail -1
	echo -ne "\taverage:\t"
	grep Encoding $1/*|awk '{print $6}'|awk '{sum+=$1}END{print sum/NR}'
	echo "TS time:"
	echo -ne "\tcount:\t"
	grep TS $1/*|wc -l
	echo -ne "\tmaximum:\t"
	grep TS $1/*|awk '{print $7}'|sort -n|tail -1
	echo -ne "\taverage:\t"
	grep TS $1/*|awk '{print $7}'|awk '{sum+=$1}END{print sum/NR}'
}
function analyze_media(){
	echo -ne "average fps:\t"
	grep -e "^frame=" $1/*|awk '{if(NF==9)sum+=$4;else sum+=$3}END{print sum/NR}'
}
function pre_work(){
	for file in $1/*
	do
		if [ -f $file ]
		then
			sed -e 's//\n/g' $file > temp.temp
			cat temp.temp > $file
		fi
	done
	rm temp.temp
}


start_time=`date +%s`
if [ $# -eq 1 ]
then
	if [ -d $1 ]
	then
		for DIR in $1/*
		do
			if [ -d $DIR -a -d "$DIR/demo_log/" ]
			then
				echo "analyzing log in $DIR"
				pre_work "$DIR/demo_log/"
				analyze "$DIR/demo_log/"
				analyze_media "$DIR/demo_log/"
			fi
		done
	fi
else
	echo "usage: $0 log_dir"
fi
stop_time=`date +%s`
used_time=$(( $stop_time - $start_time ))
echo "used $used_time seconds"
