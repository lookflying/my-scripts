#!/bin/bash
mnt_boot=boot
boot_offset=34603008
root_offset=571473920
mnt_root=root
function check()
{
	if [ $1 -ne 0 ]
	then
		echo failed!
		exit 1
	fi
}
if [ $EUID -ne 0 ]
then
	echo -n 'You need to be root or use sudo'
	exit 1
fi
if [ ! $# -eq 1 ]
then
	echo 'umount and clean'
	if [ -d $mnt_boot ]
	then
		mountpoint $mnt_boot &>/dev/null &&	umount $mnt_boot 2>/dev/null
		check $?
		rm -r $mnt_boot 
	fi
	if [ -d $mnt_root ]
	then
		mountpoint $mnt_root &>/dev/null && umount $mnt_root 2>/dev/null 
		check $?
		rm -r $mnt_root 
	fi
else
	image=$1
	echo "mount $image"
	mountpoint $mnt_boot &>/dev/null &&	umount $mnt_boot 2>/dev/null
	test -d $mnt_boot && rm -r $mnt_boot 
	mkdir $mnt_boot
	mount -o loop,rw,offset=$boot_offset $image $mnt_boot
	mountpoint $mnt_root &>/dev/null && umount $mnt_root 2>/dev/null 
	test -d $mnt_root && rm -r $mnt_root 
	mkdir $mnt_root
	mount -o loop,rw,offset=$root_offset $image $mnt_root
fi
