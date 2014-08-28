#!/bin/bash
if [ $# -eq 5 ]
then
	periods=`echo $1|sed 'y/,/ /'`
	budgets=`echo $2|sed 'y/,/ /'`
	executes=`echo $3|sed 'y/,/ /'`
	durations=`echo $4|sed 'y/,/ /'`
	log=$5
	listname=`echo $@|sed 'y/ ,/-_/'`.list
	echo $periods
	echo $budgets
	echo $executes
	echo $durations
	count=0
	echo "#$0 $@" > $listname
	echo -e "#period\tbudget\texecute\tduration\tlog\n" >> $listname

	for period in $periods
	do
		for budget in $budgets
		do
			if [ $budget -lt $period ]
			then
				for execute in $executes
				do
					if [ $execute -le $budget ]
					then
						for duration in $durations
						do
							echo -e -n "$period\t$budget\t$execute\t$duration\t$log\n" >> $listname
							count=`expr $count + 1`
						done
					fi
				done
			fi
		done
	done
	echo "generated $count task"
else
	echo "usage: $0 <period1>,<period2>,... <budget1>,<budget2>,... <exec1>,<exec2>,... <duration1>,<duration2>,... <log>"
fi

