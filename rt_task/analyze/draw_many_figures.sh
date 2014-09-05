#!/bin/bash
if [ $# -eq 1 ]
then 
	dir=$1
	files=`find $dir -maxdepth 1 -name \\*.txt|sort -V`
	declare -A period_array
	declare -A pid_array
	for file in $files
	do
		name=${file##*/}
		period=`echo $name|awk 'BEGIN{FS="_"}{printf $(NF-1);}'`
		vm_pid=`echo $name|awk 'BEGIN{FS="_"}{printf $(NF-2);}'`
		if [ -z "${period_array[$period]}" ]
		then
			period_array[$period]=$vm_pid
		else
			period_array[$period]=${period_array[$period]}","$vm_pid
		fi
		if [ -z "${pid_array[$vm_pid$period]}" ]
		then
			pid_array[$vm_pid$period]=$file
		else
			pid_array[$vm_pid$period]=${pid_array[$vm_pid$period]}","$file
		fi
	done



	for period in `echo ${!period_array[@]}|sed 'y/ /\n/'|sort -V`
	do
		echo -n -e "
\\\\begin{figure}
	\\\\centering"
		pids=`echo ${period_array[$period]}|sed 'y/,/\n/'|uniq`
		for pid in $pids
		do
			echo -n -e "
	\\\\begin{subfigure}[t]{0.48\\\\textwidth}
		\\\\centering
		\\\\begin{tikzpicture}[scale=0.6, baseline]
			\\\\begin{axis}[xlabel=Task Utilization(\\\\%), ylabel=Deadline Miss Ratio(\\\\%), legend pos=north west]"

			files=`echo ${pid_array[$pid$period]}|sed 'y/,/ /'`
			for file in $files
			do
				legend=${file%.*}
				legend=${legend##*/}
				legend=`echo $legend|sed 'y/_/ /'`
				echo -n -e "
				\\\\addplot table[x={task load}, y={miss rate after middle}, col sep=tab]{$file};
				\\\\addlegendentry{$legend};"
			done
			echo -n -e "
			\\\\end{axis}
		\\\\end{tikzpicture}
		\\\\caption{VM period = $period us}
	\\\\end{subfigure}"
		done
		echo -n -e "
	\\\\caption{Task deadline miss ratio under different virtual machine environment}
\\\\end{figure}\\n"
	done
else
	echo "usage: $0 <dir>"
fi
