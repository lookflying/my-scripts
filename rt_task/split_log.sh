#!/bin/bash
if [ $# -ge 3 ]
then
	target_dir=$1
	ref_columns=$2
	columns=$3
	names=$4
	ref_columns=${ref_columns//","/" "}
	names=`echo $names|sed 'y/,/\t/'`
	mkdir -p $target_dir
	rm -rf $target_dir/*
	while read line
	do
		if [ -n "$line" ]
		then
			key=""
			for col in $ref_columns
			do
				key=$key`echo $line|awk -v col=$col '{print $col"_"}'`
			done
			key=${key%_}
			if [ -n "$names" ] && [ ! -e $target_dir/$key".txt" ]
			then
				echo "$names" > $target_dir/$key".txt"
			fi
	#			echo $key
	#			echo $line |sed 'y/\t%#/   /'|tr -s " "|cut -d" " -f$columns --output-delimiter=" " >> $target_dir/$key".txt"
			echo $line |sed 'y/%#/  /'|awk -v columns=$columns 'BEGIN{split(columns, cols, ",")}{for(i in cols){printf $cols[i]"\t"}printf "\n"}' >> $target_dir/$key".txt"
		fi
	done
else
	echo "usage $0 target_dir ref_column1,ref_column2,ref_column3,... col1,col2,col3,... [name1,name2,name3,...]"
fi
