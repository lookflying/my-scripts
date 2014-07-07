#!/bin/bash
miss_rate=`dirname $0`/miss_rate.sh
function latest_miss_rate()
{
	if [ $# -eq 1 ]
	then
		host_dir=$1
		latest=`find $host_dir -mindepth 1 -maxdepth 1 -type d|sort -V|tail -1`
		echo $latest
		$miss_rate $latest
	fi
}

if [ $# -eq 1 ]
then
	dir=$1
	for host_info in `find $dir -maxdepth 1 -mindepth 1 -type d|sort -V`
	do
		latest_miss_rate $host_info				
	done
fi
