#!/bin/bash
if [ $# -eq 1 ]
then
	dir=$1
	echo $dir
	dir=${dir%.*}
	echo $dir
	dir=${dir%.*}
	echo $dir
fi
