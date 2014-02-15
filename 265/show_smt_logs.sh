#!/bin/bash
showlog="./show_log.sh"
if [ $# -eq 1 ]
then
	dir=$1
	for subdir in $1/*
	do
		if [ -d $subdir ]
		then
			name=${subdir##*/}_1.log
			$showlog $subdir/$name
		fi
	done
fi
