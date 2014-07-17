#!/bin/bash
while getopts :d:t:h: opt
do
	case $opt in
	d)
		dir=$OPTARG
		;;
	t)
		trace=$OPTARG
		;;
	h)
		host_trace=$OPTARG
		;;
	esac
done
if [ -n "$dir" ] && [ -n "$trace" ]
then
	temp=`mktemp`
	cat $dir/* |awk '{if($1==0){print}}'|awk '{printf $6"\tstart\t"$8"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$8"\t"$9"\t"$10"\n"$7"\tstop\t"$8"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$8"\t"$9"\t"$10"\n"}' > $temp
	trace-cmd report $trace|awk 'BEGIN{FS="."}{print $1$2}'|awk '{if(NF==10){print $3"\t"$8"\t"$1"\t"$2"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\n"}}' >> $temp
	if [ -n "$host_trace" ]
	then
		trace-cmd report $host_trace|awk 'BEGIN{FS="."}{print $1$2}'|awk '{if(NF==10){print $3"\t"$8"\t"$1"\t"$2"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\n"}}'|grep qemu-system-arm >> $temp
	fi
	cat $temp|sort -V|sed '/^$/d'
	rm $temp
else
	echo usage
	echo -e "\t-d\tdir"
	echo -e "\t-t\ttrace.dat"
	echo -e "\t-h\thost trace.dat"
fi

															 
