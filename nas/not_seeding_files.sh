#!/bin/bash
function usage()
{
	echo usage: $0 files.list torrents.list
	echo usage: $0 files_dir	torrents_dir
}
if [ $# -eq 2 ]
then
	if [ -f $1 ] && [ -f $2 ]
	then
		flist=$1
		tlist=$2
		cat $flist | \
		while read f
		do
			f="${f%/}"
			grep "$f" $tlist &>/dev/null
			if [ $? -ne 0 ]
			then
				echo $f
			fi
		done
	elif [ -d $1 ] && [ -d $2 ]
	then
		flist=`ls $1`
		tlist=`mktemp`
		ls $2 > $tlist
		echo $flist | \
		while read f
		do
			f="${f%/}"
			grep "$f" $tlist &>/dev/null
			if [ $? -ne 0 ]
			then
				echo $f
			fi
		done
	else
		usage $@		
	fi
else
	usage $@
fi
