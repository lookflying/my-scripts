#!/bin/bash
if [ $# -eq 1 ]
then
	if [ -d $1 ]
	then
		count=0
		for file in $1/* 
		do
#			echo $file
			if [ -f $file ]
			then
				dir=${file%%.*}
				ext=${file#*.}
				if [ $ext = "tar.gz" ]
				then
					count=$[$count + 1]
					if [ -d $dir ]
					then
						echo "$dir exists, nothing changed"
					else
						if [ -f $dir ]
						then
							rm -rf $dir
						fi
						echo "make dir $dir"
						mkdir $dir
						cd $dir
						echo "exact file $file"
						tar xzf $file
					fi
				fi
			fi
		done
		echo "$count processed"
		exit 0
	fi
fi
echo "usage: $0 dir"
