#!/bin/bash
function report_usage_bandwidth(){
	report_dir=$1
	tmpfile=`mktemp`
	amplxe-cl -R summary -r $report_dir 1>$tmpfile 2>/dev/null
	elapsed_time=`cat $tmpfile|grep 'Elapsed Time:'|awk '{print $3}'`
	cpu_count=`cat $tmpfile|grep 'Logical CPU Count'|awk '{print $4}'`
	cpu_usage=`cat $tmpfile|grep 'CPU Usage:'|awk -v count=$cpu_count '{print $3/count}'`
	memroy_bandwidth=`cat $tmpfile|grep 'UNC_IMC_DRAM_DATA'|awk -v t=$elapsed_time 'BEGIN{sum=0}{sum+=$2}END{print sum * 64 / 1000000000 / t}'`
	rm -rf $tmpfile
	echo -e $cpu_usage"\t"$memroy_bandwidth
}

if [ $# -eq 1 ]
then
	dir=$1
	for result in `ls $dir|sort -V`
	do
		if [ -d $dir/$result ]
		then
			echo -n -e $result"\t"
			report_usage_bandwidth $dir/$result
		fi
	done
fi
