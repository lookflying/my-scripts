#!/bin/bash
POWER_SUPPLY_PATH=/sys/class/power_supply
function get_field()
{
	if [ $# -eq 2 ]
	then
		device=$1
		field=$2
		if [ -f $device/$field ]
		then
			eval $field=`cat $device/$field`
		fi
	fi
}
if [ -d $POWER_SUPPLY_PATH ]
then
	devices=`find $POWER_SUPPLY_PATH -maxdepth 1 -mindepth 1`
	for device in $devices
	do
		dtype=`cat $device/type`
		if [ "Battery" = $dtype ]
		then
			get_field $device capacity
			get_field $device temp
			get_field $device time_to_empty_avg
			if [ -n "$capacity" ]
			then
				echo -n -e  "capacity: $capacity%\t"		
			fi
			if [ -n "$temp" ]
			then
				temp_degree=`echo "scale=1; $temp/10"|bc`
				echo -n -e  "temp: $temp_degree\t"		
			fi
			if [ -n "$time_to_empty_avg" ]
			then
				remaining_hour=`echo "scale=2; $time_to_empty_avg/60/60"|bc`
				echo -n -e  "remaining: $remaining_hour\t"		
			fi
			echo -n -e "\n"
		fi
	done
fi
