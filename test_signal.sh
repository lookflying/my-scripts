#!/bin/bash
running_thread(){
	hello_count=1
	while [ 1 ]
	do
		echo Hello $hello_count
		hello_count=`expr $hello_count + 1`
		sleep 1
	done
}

echo start
running_thread &
thread_pid=$!
sleep 4
while [ 1 ]
do
	kill -20 $thread_pid
	echo stopped
	sleep 4
	kill -18 $thread_pid
	echo continued
	sleep 4
done 
