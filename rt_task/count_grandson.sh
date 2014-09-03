#!/bin/bash
if [ $# -ge 1 ]
then
	dir=$1
else
	dir=.
fi
sons=`find $dir -maxdepth 1 -mindepth 1 -type d`
for son in $sons
do
	grandson_count=`ls $son|wc -l`
	echo -e $son"\t"$grandson_count
done
