#!/bin/bash
draw_figure=draw_many_figures.sh
if [ $# -eq 1 ]
then
	dir=$1
	$draw_figure $dir
else
	echo "usage: $0 <dir>"
fi
