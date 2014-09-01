#!/bin/bash
if [ $# -ge 3 ]
then
	target_dir=$1
	ref_columns=$2
	columns=$3
	names=$4
	ref_columns=${ref_columns//","/" "}
	names=`echo "$names"|sed 'y/,/\t/'`
	mkdir -p $target_dir
	rm -rf $target_dir/*
	declare -A files											 
	line_cnt=0
	file_cnt=0
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
	#			echo $key
	#			echo $line |sed 'y/\t%#/   /'|tr -s " "|cut -d" " -f$columns --output-delimiter=" " >> $target_dir/$key".txt"
			echo $line |sed 'y/%#/  /'|awk -v columns=$columns 'BEGIN{split(columns, cols, ",");len=length(cols)}{for(i=1; i<=len; ++i){printf $cols[i]"\t"}printf "\n"}' >> $target_dir/$key".txt"
			files[$key]=$target_dir/$key".txt"
#			echo $line |sed 'y/%#/  /'|awk -v columns=$columns 'BEGIN{split(columns, cols, ",")}{for(i in cols){printf $cols[i]"\t"}printf "\n"}' 
			line_cnt=$[ $line_cnt + 1 ]
			echo -n -e "\rprocessed $line_cnt line(s)"
		fi
	done
	echo
	for key in ${!files[@]}
	do
		file=${files[$key]}
		cat $file|sort -V >$file
		if [ -n "$names" ]
		then
			sed -i "1 i $names" $file
		fi
		file_cnt=$[ $file_cnt + 1 ]
		echo -n -e "\rgenerated $file_cnt file(s)"
	done
	echo
else
	echo "usage $0 target_dir ref_column1,ref_column2,ref_column3,... col1,col2,col3,... [name1,name2,name3,...]"
fi
