#!/bin/bash
period=10000
duration=30
step=10
hard=0

testtime=`date +%Y%m%d%H%M%S`
testname=`basename $0`
testname=${testname%.*}
path=`dirname $0`
count=$[ `ls $path|grep $testname"_"|wc -l` + 1 ]
logpath=$path/$testname"_"$count"_"$testtime


while getopts :p:s:d:h opt
do
	case $opt in
	p)#period(in millisecond)
		echo period="$OPTARG"
		period=$OPTARG
		;;
	s)#step(in percentage)
		echo step="$OPTARG""%"
		step=$OPTARG
		;;
	d)#duration(in second)
		echo duration="$OPTARG"
		duration=$OPTARG
		;;
	h)#hard realtime(exit when miss deadline)
		echo hard realtime
		hard=1
		;;
	esac
done


if [ $# -ge 2 ] || [ $hard -eq 1 ]
then
	if [ $hard -eq 1 ]
	then
		die_on_dmiss="-M"
	fi
	percentage=$step
	while [ $percentage -lt 100 ]
	do
		execution=`expr $period \* $percentage / 100`
		echo "exec=$execution"
		rt-app $die_on_dmiss -t $period:$execution:d -D $duration
		percentage=$[ $percentage + $step ]
	done
else
	echo "usage"
	echo -e "\t-p period(in millisecond), default $period"
	echo -e "\t-s step(in percentage), default $step"
	echo -e "\t-d duration(in second), default $duration"
	echo -e "\t-h hard realtime(exit when miss deadline), default $hard"
fi

