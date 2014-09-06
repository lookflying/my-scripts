#!/bin/bash
if [ $# -eq 1 ]
then 
	dir=$1
	files=`find $dir -name \\*.txt|sort -V`
	echo -n -e "
		\\\\begin{figure}\\n
		\\\\begin{tikzpicture}\\n
		\\\\begin{axis}[xlabel=Task Utilization(\\\\%), ylabel=Deadline Miss Ratio(\\\\%), legend pos=north west]\\n"
	for file in $files
	do
		legend=${file%.*}
		legend=${legend##*/}
		legend=`echo $legend|sed 'y/_/ /'`
		echo -n -e "
			\\\\addplot table[x={task load}, y={miss rate after middle}, col sep=tab]{$file};\\n
			\\\\addlegendentry{$legend};\\n"
	done
	echo -n -e "
		\\\\end{axis}\\n
		\\\\end{tikzpicture}\\n
		\\\\caption{Deadline Miss Ratio under different circumstance}\\n
		\\\\end{figure}\\n"
else
	echo "usage: $0 $dir"
fi
