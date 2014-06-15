#!/bin/bash
export DISPLAY=:0
qemu-system-arm \
		-enable-kvm -serial stdio -kernel zImage_3_14_7_vexpress\
		-m 512 -M vexpress-a15 -cpu cortex-a15 \
		-drive file=ubuntu.img,id=virtio-blk,if=none \
		-device virtio-blk,drive=virtio-blk,transport=virtio-mmio.0 \
		-device virtio-net,transport=virtio-mmio.1,netdev=net0,mac="52:54:00:12:34:55" \
		-netdev type=tap,id=net0,script=no,downscript=no,ifname="tap0" \
		-no-frame \
		-append "earlyprintk=ttyAMA0 console=ttyAMA0 mem=512M \
		virtio_mmio.device=1M@0x4e000000:74:0 \
		virtio_mmio.device=1M@0x4e100000:75:1 \
		root=/dev/vda rw ip=dhcp --no-log"
