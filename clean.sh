#!/bin/bash
target_dir=`pwd`/encoded
old=`pwd`/old
rm -rf $target_dir
if [ ! -d $old ]
then
	if [ -f $old ]
	then
		rm -rf $old
	fi
	mkdir $old
fi
mv *.log $old
