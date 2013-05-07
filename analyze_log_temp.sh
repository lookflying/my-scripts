#!/bin/bash
result="result"
gpu_top_log="gpu_top.log"
function analyze()
{
	temp=mktemp
	echo "Encoding time:"
	grep "Encoding" $1/* > $temp
	echo -ne "\taverage:\t"
	cat $temp|awk '{print $6}'|awk '{sum+=$1}END{print sum/NR}'
	echo -ne "\tcount:\t"
	cat $temp|wc -l
	echo -ne "\tmaximum:\t"
	cat $temp|awk '{print $6}'|sort -n|tail -1
	echo "TS time:"
	echo -ne "\taverage:\t"
	cat $temp|awk '{print $7}'|awk '{sum+=$1}END{print sum/NR}'
	grep "TS" $1/* > $temp
	echo -ne "\tcount:\t"
	cat $temp|wc -l
	echo -ne "\tmaximum:\t"
	cat $temp|awk '{print $7}'|sort -n|tail -1
	rm $temp
}
function analyze_media(){
	temp=mktemp
	echo -ne "average fps:\t"
	grep -e "^frame=" $1/* > $temp 
	cat	$temp|awk '{if(NF==9)sum+=$4;else sum+=$3}END{print sum/NR}'
	echo -ne "total "
	cat	$temp|awk '{if(NF==9)print $8;else if(NF==8)print $7;else print $6}'|sort|tail -1
	rm $temp

}
function pre_work(){
	temp=mktemp
	for file in $1/*
	do
		if [ -f $file ]
		then
			sed -e 's//\n/g' $file > $temp
			cat $temp > $file
		fi
	done
	rm $temp
}
function analyze_vtune(){
if [ -f $1/vtune* ]
then
	cpu_usage=`grep "CPU Usage:" $1/vtune* |awk '{print $3}'`
	echo Vtune Cpu Usage = $cpu_usage%
fi
}

function analyze_gpu_top(){
	file=$1
	cat $file|awk '{
						if (NR > 1){
							render_sum+=$2
							bitstr_sum+=$6
						}
					}
					END{
							printf "GPU Render %3.2f%%\tBitstr %3.2f%%\n", render_sum/(NR-1), bitstr_sum/(NR-1)
					}'
}

function analyze_print(){
	directory=$1
	children=$2
	if [ -d $directory -a -d "$directory/$children/demo_log" ]
	then
		echo "analyzing log in $dir"
		if [ -f $directory/$result ]
		then
			echo "(found previous result, just display)"
			cat $directory/$result
		else
			pre_work "$directory/$children/demo_log"
			analyze "$directory/$children/demo_log/" |tee $directory/$result
			analyze_media "$directory/$children/demo_log/"|tee -a $directory/$result
#			analyze_vtune "$directory/$children/demo_log/"|tee -a $directory/$result
			analyze_gpu_top "$directory/$children/demo_log/$gpu_top_log"|tee -a $directory/$result
		fi
	fi
}



start_time=`date +%s`
if [ $# -eq 1 ]
then
	if [ -d $1 ]
	then
		for dir in `ls $1|sort --version-sort`
		do
			analyze_print "$1/$dir" "."
			analyze_print "$1/$dir" "root/MC/MediaCloud"
		done
	fi
else
	echo "usage: $0 log_dir"
fi
stop_time=`date +%s`
used_time=$(( $stop_time - $start_time ))
echo "used $used_time seconds"
