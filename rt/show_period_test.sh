#!/bin/bash
if [ $# -eq 1 ]
then
	./show_vm_result.sh $1|awk '{if(NF==1){printf "\n"$1"\t";count=0}else{if(NF==5&&count!=0){printf $5"\t"};count=count+1}}'|sed 's/.*vm\/\(.*\)_[0-9]*\/realtime[0-9_]*[[:space:]]\(.*\)/\1\t\2\n /g'
	echo
fi
