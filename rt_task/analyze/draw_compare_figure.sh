#!/bin/bash
if [ $# -eq 1 ]
then 
	dir=$1
	files=`find $dir -name \\*.txt|sort -V`
	declare -A file_array
	for file in $files
	do
		name=${file##*/}
		key=`echo $name|cut -d_ -f1`
		if [ -z "${file_array[$key]}" ]
		then
			file_array[$key]=$file
		else
			file_array[$key]=${file_array[$key]}","$file
		fi
	done
	echo -n -e "
\\\\begin{figure}
	\\\\centering"
	
	for key in `echo ${!file_array[@]}|sed 'y/ /\n/'|sort -V`
	do
	echo -n -e "
	\\\\begin{subfigure}[t]{0.48\\\\textwidth}
		\\\\centering
		\\\\begin{tikzpicture}[scale=0.6, baseline]
			\\\\begin{axis}[xlabel=Task Utilization(\\\\%), ylabel=Deadline Miss Ratio(\\\\%), legend pos=north west]"
	files=`echo ${file_array[$key]}|column -ts,`
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
		\\\\caption{VM period = $key us}
	\\\\end{subfigure}"
	done
	echo -n -e "
	\\\\caption{Task deadline miss ratio under multiple virtual machine environment}
\\\\end{figure}\\n"
else
	echo "usage: $0 <dir>"
fi
