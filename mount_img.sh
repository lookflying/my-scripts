#!/bin/bash
mnt_boot=boot
boot_offset=34603008
root_offset=571473920
mnt_root=root
if [ $EUID -ne 0 ]
then
	echo 'You need to be root or use sudo'
	exit 1
fi
if [ ! $# -eq 1 ]
then
	echo 'usage: $0 <img>'
else
	image=$1
	mountpoint $mnt_boot >/dev/null &&	umount $mnt_boot 2>/dev/null
	rm -r $mnt_boot 
	mkdir $mnt_boot
	mount -o loop,rw,offset=$boot_offset $image $mnt_boot
	mountpoint $mnt_root >/dev/null && umount $mnt_root 2>/dev/null 
	rm -r $mnt_root 
	mkdir $mnt_root
	mount -o loop,rw,offset=$root_offset $image $mnt_root
fi
