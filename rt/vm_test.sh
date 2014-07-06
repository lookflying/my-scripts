#!/bin/bash

qemu_tid_file="/run/qemu.tid"
function get_qemu_tid()
{
	if [ -f $qemu_tid_file ]
	then
		cat $qemu_tid_file
	else
		echo 0
	fi	
}

get_qemu_tid
