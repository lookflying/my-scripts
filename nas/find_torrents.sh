#!/bin/bash
function usage()
{
	echo usage: $0 files.list torrents.list
	echo usage: $0 files_dir	torrents_dir
}
function grep_files_in_torrents()
{
		flist=$1
		tlist=$2
		cat $flist | \
		while read f
		do
			f="${f%/}"
			grep -F "$f" $tlist
		done
}
if [ $# -eq 2 ]
then
	if [ -f $1 ] && [ -f $2 ]
	then
		grep_files_in_torrents $@
	elif [ -d $1 ] && [ -d $2 ]
	then
		flist=`mktemp /tmp/temp.XXXXXX`
		tlist=`mktemp /tmp/temp.XXXXXX`
		ls $1 >$flist
		ls $2 >$tlist
		grep_files_in_torrents $flist $tlist
	else
		usage $@		
	fi
else
	usage $@
fi
