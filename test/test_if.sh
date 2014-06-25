#!/bin/bash
for i in 0 1 2 3 4 5 6 7
do
	if [ $i ]
	then
		echo $i
	fi
done

echo "test -n -z"
string=""
if [ -n "$string" ]
then
	echo "-n string = true"
else
	echo "-n string = false"
fi
if [ -z "$string" ]
then
	echo "-z string = true"
else
	echo "-z string = false"
fi

