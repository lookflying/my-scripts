#!/bin/bash
if [ $# -ge 3 ]
then
	user_ip=$1
	working_dir=$2
	shift 2
	cmd=$@
	ssh $user_ip <<-END_OF_CMD
		cd $working_dir
		nohup $cmd &>/dev/null &
	END_OF_CMD
else
	echo "usage: $0 <user>@<ip> <working_dir> <cmd>...."
fi
