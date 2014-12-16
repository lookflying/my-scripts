#!/bin/bash
param=$1
period=${param%:*}
budget=${param#*:}
duration=$2
echo $period $budget $duration
for ratio in 0 10 20 30 40 50 60 70 80 90 100
do
	execution=`expr $budget \* $ratio / 100`
	rt_task $period:$budget:$execution $duration 0
done
