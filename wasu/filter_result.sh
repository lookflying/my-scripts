#!/bin/bash

function get_latency_fps(){
	result=$1
	line=$2
	latency=`sed -n "$line,/average:/p" $result|sed -n "/average:/p"|awk '{print $2}'`
	fps=`sed -n "$line,/average fps/p" $result|sed -n "/average fps/p"|awk '{print $3}'`
	echo -e $latency"\t"$fps
}
result=$1
lines=`cat $result|grep "analyzing log" -n|awk 'BEGIN{FS=":| "}{print $1}'`
for line in $lines
do
	title=`sed -n $line"p" $result|awk '{print $4}'`
	echo -n -e $title"\t"
	get_latency_fps $result $line
done
