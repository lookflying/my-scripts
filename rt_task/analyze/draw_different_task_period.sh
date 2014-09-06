#!/bin/bash
draw_figure=draw_many_figures.sh
if [ $# -eq 1 ]
then
	dir=$1
	log_dirs=`find $dir -maxdepth 1 -mindepth 1 -type d |sort -V`
	for fig_dir in $log_dirs
	do
		echo $fig_dir 1>&2
		$draw_figure $fig_dir
	done
else
	echo "usage: $0 <dir>"
fi
