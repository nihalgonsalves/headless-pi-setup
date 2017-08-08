#!/bin/bash

default_raspbian="$IMG_DIR/raspbian.img"
raspbian=${1:-$default_raspbian}

image_sectors=$(fdisk -o start --units=sectors -l $raspbian)
image_sizes=$(fdisk -o size --bytes -l $raspbian | tail -n 2)

partitions=$(echo -e "$image_sectors" | tail -n 2)
sector_size=$(echo -e "$image_sectors" | perl -lne 'print $1 if /Units.*= (.*) bytes/')

boot_sector_offset=$(echo -e "$partitions" | sed '1q;d')
os_sector_offset=$(echo -e "$partitions" | sed '2q;d')

boot_byte_offset=$(($boot_sector_offset*$sector_size))
os_byte_offset=$(($os_sector_offset*$sector_size))

boot_sizelimit=$(echo -e "$image_sizes" | sed '1q;d' | xargs)
os_sizelimit=$(echo -e "$image_sizes" | sed '2q;d' | xargs)

mount -v -o offset=$boot_byte_offset,sizelimit=$boot_sizelimit -t auto $raspbian $PI_BOOT_MOUNT
mount -v -o offset=$os_byte_offset,sizelimit=$os_sizelimit -t auto $raspbian $PI_OS_MOUNT

echo "[headless-pi-setup] Mounted"
