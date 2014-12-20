#!/bin/bash
function all_equal()
{
	if [ $# -lt 1 ]
	then
		return 1
	fi
	first=$1
	for value in $@
	do
		if [ $first -ne $value ]
		then
			return 1
		fi
	done
	return 0
}
r_period="(?<=period\\s=\\s)\d+(?=\\sns)"
r_budget="(?<=budget\\s=\\s)\d+(?=\\sns)"
r_execution="(?<=exec\\s=\\s)\d+(?=\\sns)"
r_misscnt="(?<=miss_cnt=\\s)\\d+(?=\\s)"
r_misscntratio="miss_cnt=\\s\\d+\s\\K\\d+\\.\\d+(?=%)"
r_misscnt_aftermiddle="(?<=miss_cnt_after_middle=\\s)\\d+(?=\\s)"
r_misscntratio_aftermiddle="miss_cnt_after_middle=\\s\\d+\s\\K\\d+\\.\\d+(?=%)"

logfile=$1
periods=(`grep -o -P -e "$r_period" $logfile`)
budgets=(`grep -o -P -e "$r_budget" $logfile`)
executions=(`grep -o -P -e "$r_execution" $logfile`)
misscnts=(`grep -o -P -e "$r_misscnt" $logfile`)
misscntratios=(`grep -o -P -e "$r_misscntratio" $logfile`)
misscnt_aftermiddles=(`grep -o -P -e "$r_misscnt_aftermiddle" $logfile`)
misscntratio_aftermiddles=(`grep -o -P -e "$r_misscntratio_aftermiddle" $logfile`)
#echo ${periods[@]}
#echo ${budgets[@]}
#echo ${executions[@]}
#echo ${misscnts[@]}
#echo ${misscntratios[@]}
#echo ${misscnt_aftermiddles[@]}
#echo ${misscntratio_aftermiddles[@]}

if ! all_equal ${#periods[@]} ${#budgets[@]} ${#executions[@]} ${#misscnts[@]} ${#misscntratios[@]} ${#misscnt_aftermiddles[@]} ${#misscntratio_aftermiddles[@]}
then
	echo not all equal
	exit 1
fi


if all_equal ${periods[@]} && all_equal ${budgets[@]}
then
	echo -e -n "period\tbudget\texec\tutility\tmiss\tratio\tmiss am\tratio am\n"
	cnt=${#periods[@]}
	for ((i=0; i<$cnt; ++i))
	do
		utility=`expr ${executions[$i]} \* 100 / ${periods[$i]}`
		echo -e -n  "${periods[$i]}\t${budgets[$i]}\t${executions[$i]}\t$utility\t${misscnts[$i]}\t${misscntratios[$i]}\t${misscnt_aftermiddles[$i]}\t${misscntratio_aftermiddles[$i]}\n"
	done
else
	echo not equal
fi

