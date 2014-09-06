#!/bin/bash
while getopts :o:c:n: opt
do
	case $opt in
	o)
		operation="$OPTARG"
		;;
	c)
		column="$OPTARG"
		;;
	n)
		column_name="$OPTARG"
		column_name=`echo $column_name|sed 'y/_/ /'`
		;;
	esac
done

shift $[ $OPTIND - 1]

if [ $# -ge 1 ]
then
	files=$@
	tmp_file=`mktemp`
	for file in $files
	do
		case $operation in
		min)
			awk -v col=$column -v name="$column_name" '
				BEGIN{
					first=1;
					last=0;
				}
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\t"name"\n";
						next;
					}
					if(first)
					{
						first = 0;
						last = $col;
						value = $col;
					}
					else
					{
						value = (last > $col ? $col : last);
						last = value;
					}
					printf $0"\t"value"\n"
				}' $file |tee $tmp_file
			mv $tmp_file $file
			;;
		max)
			awk -v col=$column -v name="$column_name" '
				BEGIN{
					first=1;
					last=0;
				}
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\t"name"\n";
						next;
					}
					if(first)
					{
						first = 0;
						last = $col;
						value = $col;
					}
					else
					{
						value = (last < $col ? $col : last);
						last = value;
					}
					printf $0"\t"value"\n"
				}' $file |tee $tmp_file
			mv $tmp_file $file
			;;
		add)
			awk -v col=$column -v name="$column_name" '
				BEGIN{
					first=1;
					last=0;
				}
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\t"name"\n";
						next;
					}
					if(first)
					{
						first = 0;
						last = $col;
						value = $col;
					}
					else
					{
						value =	value + $col; 
						last = value;
					}
					printf $0"\t"value"\n"
				}' $file |tee $tmp_file
			mv $tmp_file $file
			;;
			add_normal)
			awk -v col=$column -v name="$column_name" '
				BEGIN{
					first=1;
					last=0;
				}
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\t"name"\n";
						next;
					}
					if(first)
					{
						first = 0;
						last = $col;
						value = $col;
					}
					else
					{
						value =	value + $col; 
						last = value;
					}
					printf $0"\t"value"\n"
				}' $file |tee $tmp_file
			max_value=`tail -1 $tmp_file|awk '{print $NF}'`
			awk -v max_value=$max_value '
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\n";
						next;
					}
					$NF = $NF / max_value * 100;
					for(i = 1; i < NF; ++i)
					{
						printf $i"\t"
					}
					printf $NF"\n"
				}' $tmp_file | tee $file
			;;		
		esac
	done
else
	echo "usage: $0 -o min|max|add|add_normal -c <column> -n <column_name> <file1> <file2> ..."
fi
