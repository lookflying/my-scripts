#!/bin/bash
if [ $# -eq 1 ]
then
	rootdir=$1
	for logdir in `ls $rootdir|grep tasks|sort -V`
	do
		./show_logs.sh $rootdir/$logdir | awk '
		BEGIN{max=0;frames=0;}
		{
			if(max<$4){max=$4}
			frame+=$3
		}
		END{print $1"\t"frame"\t"max"\t"frame/max"\t"$6"\t"$7"\t"$8}'	
	done
fi
