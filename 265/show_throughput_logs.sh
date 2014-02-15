#!/bin/bash
if [ $# -eq 1 ]
then
	rootdir=$1
	for logdir in `ls $rootdir|grep tasks|sort -V`
	do
		./show_logs.sh $rootdir/$logdir | awk '
		BEGIN{max=0;frames=0;psnr_y=0;psnr_u=0;psnr_v=0}
		{
			if(max<$4){max=$4}
			frame+=$3
			if(psnr_y<$6){psnr_y=$6;psnr_u=$7;psnr_v=$8}
		}
		END{print $1"\t"frame"\t"max"\t"frame/max"\t"psnr_y"\t"psnr_u"\t"psnr_v}'	
	done
fi
