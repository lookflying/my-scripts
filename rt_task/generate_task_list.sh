#!/bin/bash
period=10000
budget_min=50
budget_max=100
budget_step=10
budget_count=
period_budget_gap=50
exec_min=0
exec_max=100
exec_step=10
exec_count=
budget_exec_gap=20
if [ $# -eq 5 ]
then
	periods=`echo $1|sed 'y/,/ /'`
	echo $periods
	eval `echo $2|awk 'BEGIN{FS=":"}{if(NF==5){print "budget_min="$1";budget_max="$2";budget_step="$3";budget_count="$4";budget_gap="$5";"}else{print "echo "$0" "NF";exit 1"} }'`
#	echo $budget_min" "$budget_max" "$budget_step" "$budget_count" "$budget_gap
	eval `echo $3|awk 'BEGIN{FS=":"}{if(NF==5){print "exec_min="$1";exec_max="$2";exec_step="$3";exec_count="$4";exec_gap="$5";"}else{print "echo "$0" "NF";exit 1"} }'`
#	echo $exec_min" "$exec_max" "$exec_step" "$exec_count" "$exec_gap
	duration=$4
	log=$5

	if [ $budget_count -ne 0 ]
	then
		budget_step=`expr \( $budget_max - $budget_min \) / $budget_count`
	fi

	if [ $budget_step -eq 0 ]
	then
		echo "budget step is too small or zero"
		exit 1
	fi


	if [ $exec_count -ne 0 ]
	then
		exec_step=`expr \( $exec_max - $exec_min \) / $exec_count`
	fi

	if [ $exec_step -eq 0 ]
	then
		echo "execute step is too small or zero"
		exit 1
	fi

	if [ -z "$budget_gap" ] || [ $budget_gap -le 0 ]
	then
		budget_gap=1
	fi

	if [ -z "$exec_gap" ] || [ $exec_gap -le 0 ]
	then
		exec_gap=1
	fi
	
	echo $budget_min" "$budget_max" "$budget_step" "$budget_count" "$budget_gap
	echo $exec_min" "$exec_max" "$exec_step" "$exec_count" "$exec_gap
	

	listname=`echo $@|sed 'y/ :,/-__/'`.list
	echo $listname
	echo "#$0 $@" > $listname
	echo -e "#period\tbudget\texecute\tduration\tlog\n" >> $listname

	count=0
	for period in $periods
	do
		budget=`expr $period \* $budget_min / 100`
		budget_roof1=`expr $period \* $budget_max / 100`
		budget_roof2=`expr $period - $budget_gap`
		if [ $budget_roof1 -le $budget_roof2 ]
		then
			budget_roof=$budget_roof1
		else
			budget_roof=$budget_roof2
		fi
	
		exec_roof1=`expr $period \* $exec_max / 100`
		exec_roof2=`expr $period - $exec_gap`
		if [ $exec_roof1 -le $exec_roof2 ]
		then
			exec_roof=$exec_roof1
		else
			exec_roof=$exec_roof2
		fi
	
		while [ $budget -le $budget_roof ]
		do
			execute=`expr $period \* $exec_min / 100`
			while [ $execute -le $budget ] && [ $execute -le $exec_roof ]
			do
				echo -e -n "$period\t$budget\t$execute\t$duration\t$log\n" >> $listname
				execute=`expr $execute + $period \* $exec_step / 100`
				count=`expr $count + 1`
			done
			budget=`expr $budget + $period \* $budget_step / 100`
		done
	done
	echo "generated $count task"
else
	echo "usage: $0 <period> <budget_min>:<budget_max>:<step>:<count>:<gap> <exec_min>:<exec_max>:<step>:<count>:<gap> <duration> <log>"
	echo "ps: count overwrite step"
fi

