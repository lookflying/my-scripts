#!/bin/bash
while getopts :o:c:n: opt
do
	case $opt in
	o)
		operation="$OPTARG"
		;;
	c)
		columns="$OPTARG"
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
	column1=`echo $columns|cut -d, -f1`
	column2=`echo $columns|cut -d, -f2`
	tmp_file=`mktemp`
	for file in $files
	do
		case $operation in
		min)
			awk -v c1=$column1 -v c2=$column2 -v name="$column_name" '
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\t"name"\n";
						next;
					}
					value = ($c1 > $c2 ? $c2 : $c1);
					printf $0"\t"value"\n"
				}' $file |tee $tmp_file
			mv $tmp_file $file
			;;
		max)
		awk -v c1=$column1 -v c2=$column2 -v name=$column_name '
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\t"name"\n";
						next;
					}
					value = ($c1 > $c2 ? $c1 : $c2);
					printf $0"\t"value"\n"
				}' $file |tee $tmp_file
			mv $tmp_file $file
			;;
		add)
		awk -v c1=$column1 -v c2=$column2 -v name=$column_name '
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\t"name"\n";
						next;
					}
					value = $c1 + $c2;
					printf $0"\t"value"\n"
				}' $file |tee $tmp_file
			mv $tmp_file $file
			;;
		sub)
		awk -v c1=$column1 -v c2=$column2 -v name=$column_name '
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\t"name"\n";
						next;
					}
					value = $c1 - $c2;
					printf $0"\t"value"\n"
				}' $file |tee $tmp_file
			mv $tmp_file $file
			;;
		mul)
		awk -v c1=$column1 -v c2=$column2 -v name=$column_name '
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\t"name"\n";
						next;
					}
					value = $c1 * $c2;
					printf $0"\t"value"\n"
				}' $file |tee $tmp_file
			mv $tmp_file $file
			;;
		div)
		awk -v c1=$column1 -v c2=$column2 -v name=$column_name '
				{
					if(NR == 1 && $NF + 0 != $NF)
					{
						printf $0"\t"name"\n";
						next;
					}
					value = $c1 / $c2;
					printf $0"\t"value"\n"
				}' $file |tee $tmp_file
			mv $tmp_file $file
			;;
		esac
	done
else
	echo "usage: $0 -o min|max|add|sub|mul|div -c <column1>,<column2> -n <column_name> <file1> <file2> ..."
fi
