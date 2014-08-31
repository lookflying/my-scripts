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
			awk -v value=$value -v col=$column 'BEGIN{found=0;line="";}{if($col < value){found=1;line=$0}}END{if(found){print line}}' $log 
			;;
		le)
			awk -v value=$value -v col=$column 'BEGIN{found=0;line="";}{if($col <= value){found=1;line=$0}}END{if(found){print line}}' $log
			;;
		eq)
			awk -v value=$value -v col=$column 'BEGIN{found=0;line="";}{if($col == value){found=1;line=$0}}END{if(found){print line}}' $log 
			;;
		ge)
			awk -v value=$value -v col=$column 'BEGIN{found=0;line="";}{if($col >= value){found=1;line=$0}}END{if(found){print line}}' $log 
			;;
		gt)
			awk -v value=$value -v col=$column 'BEGIN{found=0;line="";}{if($col > value){found=1;line=$0}}END{if(found){print line}}' $log 
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
