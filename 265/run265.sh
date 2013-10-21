#!/bin/bash
function encode(){
	while [ 1 ]
	do
		ffmpeg -i /home/projects/265/1080pvideo/Lord.of.the.Rings.The.Fellowship.of.the.Ring.....mov -vcodec liblenthevchm91 -b:v 2000k -keyint_min 200 -threads 41 -preset ultrafast -wpp 13 -acodec copy /home/projects/lord_of_the_rings_2000k.flv -y 
	done
}

running=1
function pause_encoding(){
	if [ $running -eq 1 ]
	then
#		kill -20 $encode_pid
		killall -s SIGTSTP ffmpeg
		running=0
		echo -e "\nEncoding paused..."
	else
		echo -e "\nResuming encoding..."
#		kill -18 $encode_pid
		killall -s SIGCONT ffmpeg
		running=1
	fi
}

function exit_encoding(){
	kill -9 $encode_pid
	killall -SIGKILL ffmpeg
	echo -e "\nExiting encoding..."
	exit 0
}


encode &
encode_pid=$!
trap "exit_encoding" SIGQUIT 
trap "pause_encoding" SIGINT SIGTERM 
while [ 1 ]
do
	sleep 1
done
