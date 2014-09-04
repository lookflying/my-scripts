#!/bin/bash
function last_line()
{
	logs=$@
	for log in $logs
	do
		echo -n -e $log"\t"
		if [ -n "$sort_column" ]
		then
			case $operation in
			lt)
				sort --key=$sort_column -V $log|awk -v value=$value -v col=$column 'BEGIN{last="";}{if($col + 0 == $col){if($col < value){printf last;exit}else{last=$0}}}'
				;;
			le)
				sort --key=$sort_column -V $log|awk -v value=$value -v col=$column 'BEGIN{last="";}{if($col + 0 == $col){if($col <= value){printf last;exit}else{last=$0}}}'
				;;
			eq)
				sort --key=$sort_column -V $log|awk -v value=$value -v col=$column 'BEGIN{last="";}{if($col + 0 == $col){if($col == value){printf last;exit}else{last=$0}}}'
				;;
			ge)
				sort --key=$sort_column -V $log|awk -v value=$value -v col=$column 'BEGIN{last="";}{if($col + 0 == $col){if($col >= value){printf last;exit}else{last=$0}}}'
				;;
			gt)
				sort --key=$sort_column -V $log|awk -v value=$value -v col=$column 'BEGIN{last="";}{if($col + 0 == $col){if($col > value){printf last;exit}else{last=$0}}}'
				;;
			*)
				echo operation \"$operation\" not supported
				exit 1
				;;
			esac
		else
			case $operation in
			lt)
				awk -v value=$value -v col=$column 'BEGIN{last="";}{if($col + 0 == $col){if($col < value){printf last;exit}else{last=$0}}}' $log 
				;;
			le)
				awk -v value=$value -v col=$column 'BEGIN{last="";}{if($col + 0 == $col){if($col <= value){printf last;exit}else{last=$0}}}' $log 
				;;
			eq)
				awk -v value=$value -v col=$column 'BEGIN{last="";}{if($col + 0 == $col){if($col == value){printf last;exit}else{last=$0}}}' $log 
				;;
			ge)
				awk -v value=$value -v col=$column 'BEGIN{last="";}{if($col + 0 == $col){if($col >= value){printf last;exit}else{last=$0}}}' $log 
				;;
			gt)
				awk -v value=$value -v col=$column 'BEGIN{last="";}{if($col + 0 == $col){if($col > value){printf last;exit}else{last=$0}}}' $log 
				;;
			*)
				echo operation \"$operation\" not supported
				exit 1
				;;
			esac
		fi
		echo
	done
}

while getopts :o:v:c:s: opt
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
	s)
		sort_column=$OPTARG
		;;
	esac
done

shift $[ $OPTIND - 1]

if [ $# -ge 1 ] && [ -n "$column" ] && [ -n "$operation" ] && [ -n "$value" ] 
then
	logs=$@
	header=""
	for log in $logs
	do
		if [ -z "$header" ]
		then
			header=`head -1 $log`
		else
			firstline=`head -1 $log`
			if [ "$header" != "$firstline" ]
			then
				header=""
				break;
			fi
		fi
	done
	if [ -n "$header" ]
	then
		echo -e "file\t"$header
	fi

	last_line $logs|sort -V
	else
	echo "usage: $0 -c <column> -o <operation> -v <value> -s <sort_column> <logfile1> <logfile2> ..."
	echo -e "\t-c\tcolumn"
	echo -e "\t-o\toperation, support lt le eq ge gt"
	echo -e "\t-v\tvalue"
	echo -e "\t-s\tsort_column, default null, if set, sort according to sort_column, then parse"
fi
