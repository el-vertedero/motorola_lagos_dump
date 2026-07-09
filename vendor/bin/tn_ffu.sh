#!/vendor/bin/sh

#
# Copyright (c) Ontim Technologies Co., Ltd. 2023-2023. All rights reserved.
#

# easy way to get shell log
exec > /dev/kmsg 2>&1

echo "mmc_ffu start"

mmc_manfid=`cat /sys/block/mmcblk0/device/manfid`
mmc_name=`cat /sys/block/mmcblk0/device/name`
mmc_fwrev=`cat /sys/block/mmcblk0/device/fwrev`

echo mmc_manfid=$mmc_manfid
echo mmc_name=$mmc_name
echo mmc_fwrev=$mmc_fwrev

setprop ro.hardware.mmc.manfid $mmc_manfid
setprop ro.hardware.mmc.name $mmc_name
setprop ro.hardware.mmc.fwver $mmc_fwrev

mmc_ffu=

if [ "$mmc_manfid" = "0x0000d6" ]; then
	if [ "$mmc_name" = "C21E00" ]; then  # hosin 64GB
		if [ "$mmc_fwrev" = "0x0100000000000000" ]; then
			/vendor/bin/mmc ffu /vendor/firmware/64GB_FW02_for_Moto_FFU.bin /dev/block/mmcblk0 && mmc_ffu=FW01-to-FW02
		elif [ "$mmc_fwrev" = "0x6300000000000000" ]; then
			/vendor/bin/mmc ffu /vendor/firmware/64GB_FW02_for_Moto_FFU.bin /dev/block/mmcblk0 && mmc_ffu=FW99-to-FW02
		fi
	fi
fi

echo mmc_ffu=$mmc_ffu

test -n "$mmc_ffu" && setprop sys.powerctl reboot,ffu,$mmc_manfid,$mmc_name,$mmc_ffu

echo "mmc_ffu end"
