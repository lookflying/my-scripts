#!/bin/bash
if [ $# -eq 1 ] && [ -d $1 ]
then
	for file in $1/*.zip
	do
		unzip $file -d $1
	done
fi
