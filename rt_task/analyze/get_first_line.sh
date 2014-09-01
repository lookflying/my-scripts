#!/bin/bash
while getopts :o:v:c: opt
do
	case $opt in
	o)
#		echo operation = $OPTARG
		operation=$OPTARG
		;;
	v)
#		echo value = $OPTARG
		value=$OPTARG
		;;
	c)
#		echo column = $OPTARG
		column=$OPTARG
		;;
	esac
done

shift $[ $OPTIND - 1]

if [ $# -ge 1 ] && [ -n "$column" ] && [ -n "$operation" ] && [ -n "$value" ] 
then
	logs=$@
	for log in $logs
	do
		echo -n -e $log"\t"
		case $operation in
		lt)
			awk -v value=$value -v col=$column '{if($col + 0 == $col && $col < value){print $0;exit}}' $log 
			;;
		le)
			awk -v value=$value -v col=$column '{if($col + 0 == $col && $col <= value){print $0;exit}}' $log
			;;
		eq)
			awk -v value=$value -v col=$column '{if($col + 0 == $col && $col == value){print $0;exit}}' $log
			;;
		ge)
			awk -v value=$value -v col=$column '{if($col + 0 == $col && $col >= value){print $0;exit}}' $log
			;;
		gt)
			awk -v value=$value -v col=$column '{if($col + 0 == $col && $col > value){print $0;exit}}' $log
			;;
		*)
			echo operation \"$operation\" not supported
			exit 1
			;;
		esac
	done
else
	echo "usage: $0 -c <column> -o <operation> -v <value> <logfile1> <logfile2> ..."
	echo -e "\t-c\tcolumn"
	echo -e "\t-o\toperation,support lt le eq ge gt"
	echo -e "\t-v\tvalue"
fi
