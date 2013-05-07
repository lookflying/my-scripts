#!/bin/bash
if [ $# -eq 1 ]
then
	dir=$1
	for children in `ls $dir|sort --version-sort`
	do
		echo $children
	done
fi
