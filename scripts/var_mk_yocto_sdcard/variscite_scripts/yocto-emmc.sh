#!/bin/bash
#
# Flash Yocto into eMMC for DART-MX6
#

# partition size in MB
BOOTLOAD_RESERVE=4
BOOT_ROM_SIZE=8
SPARE_SIZE=40


if [ `dmesg |grep UltraLite | wc -l` = 1 ] ; then
	echo "Variscite Flash DART-6UL eMMC utility version 01"
	echo "================================================"
else
	echo "================================================="
	echo " yocto-dart.sh is compatible with DART-MX6 only. "
	echo " Please use nand-recovery or:                    "
	echo " android_emmc.sh, yocto_emmc.sh, yocto_nand.sh   "
	echo "================================================="
	read -p "Press any key to continue... " -n1 -s
fi

cd /opt/images/Yocto
#if [ ! -f SPL.mmc ]
#then
#	echo "SPL does not exist! exit."
#	exit 1
#fi	
if [ ! -f u-boot.img-sd ]
then
	echo "u-boot.img-sd does not exist! exit."
	exit 1
fi	


help() {

bn=`basename $0`
cat << EOF
usage $bn <option> device_node

options:
  -h				displays this help message
  -s				only get partition size
EOF

}

# check the if root?
userid=`id -u`
if [ $userid -ne "0" ]; then
	echo "you're not root?"
	exit
fi


# parse command line
moreoptions=1
node="/dev/mmcblk1"
cal_only=0

if [ ! -e ${node} ]; then
	echo "============================================"
	echo " can't find ${node}.                        "
	echo " Make sure you booted with:                 "
        echo " fdt_file=imx6ul-var-dart-sd_emmc.dtb       "
        echo " Also make sure that this is not NAND SOM   "
	echo "============================================"
	exit
fi

function format_yocto
{
    echo "formating yocto partitions"
    echo "=========================="
    umount /run/media/mmcblk1p1 2>/dev/null
    umount /run/media/mmcblk1p2 2>/dev/null
    mkfs.vfat /dev/mmcblk1p1 -nBOT_DART6UL
    mkfs.ext4 /dev/mmcblk1p2 -Lrootfs
    sync
}

function flash_yocto
{
    echo "flashing yocto "
    echo "==============="

    cd /opt/images/Yocto
    echo "flashing U-BOOT ..."
    mount | grep mmcblk1   
    sudo dd if=SPL-sd of=/dev/mmcblk1 bs=1K seek=1; sync
    sudo dd if=u-boot.img-sd of=/dev/mmcblk1 bs=1K seek=69; sync

    echo "flashing Yocto BOOT partition ..."    
    mkdir -p /tmp/media/mmcblk1p1
    mkdir -p /tmp/media/mmcblk1p2
    mount -t vfat /dev/mmcblk1p1  /tmp/media/mmcblk1p1
    mount /dev/mmcblk1p2  /tmp/media/mmcblk1p2
    cp zImage-imx6ul-var-dart-emmc_wifi.dtb	/tmp/media/mmcblk1p1/imx6ul-var-dart-emmc_wifi.dtb
    cp zImage-imx6ul-var-dart-nand_wifi.dtb	/tmp/media/mmcblk1p1/imx6ul-var-dart-nand_wifi.dtb
    cp zImage-imx6ul-var-dart-sd_emmc.dtb	/tmp/media/mmcblk1p1/imx6ul-var-dart-sd_emmc.dtb
    cp zImage-imx6ul-var-dart-sd_nand.dtb	/tmp/media/mmcblk1p1/imx6ul-var-dart-sd_nand.dtb
    cp zImage       				/tmp/media/mmcblk1p1/zImage

    echo "flashing Yocto Root file System ..."    
    rm -rf /tmp/media/mmcblk1p2/*
    tar xvpf rootfs.tar.bz2 -C /tmp/media/mmcblk1p2/ 2>&1 |
    while read line; do
        x=$((x+1))
        echo -en "$x extracted\r"
    done
}


#
umount /run/media/mmcblk1p1 2>/dev/null
umount /run/media/mmcblk1p2 2>/dev/null
umount /run/media/mmcblk1p1 2>/dev/null
umount /run/media/mmcblk1p2 2>/dev/null
umount /run/media/mmcblk1p* 2>/dev/null
#

# Delete any partition.
fdisk /dev/mmcblk1 1>/dev/null 2>/dev/null <<EOF 
d
1
d
2
d
3
d
w
EOF

# destroy the partition table
dd if=/dev/zero of=/dev/mmcblk1 bs=1024 count=4096

# Create new partition table
fdisk /dev/mmcblk1 <<EOF 
n
p
1
8192
24575
t
c
n
p
2
24576

p
w
EOF

# call sfdisk to create partition table
# get total card size
seprate=40
total_size=`sfdisk -s ${node}`
total_size=`expr ${total_size} / 1024`
boot_rom_sizeb=`expr ${BOOT_ROM_SIZE} + ${BOOTLOAD_RESERVE}`
rootfs_size=`expr ${total_size} - ${boot_rom_sizeb} - ${SPARE_SIZE} + ${seprate}`

echo "ROOT SIZE=${rootfs_size} TOTAl SIZE=${total_size} BOOTROM SIZE=${boot_rom_sizeb}"
echo "======================================================"
# create partitions 
#if [ "${cal_only}" -eq "1" ]; then
#cat << EOF
#BOOT   : ${boot_rom_sizeb}MB
#ROOT   : ${rootfs_size}MB
#EOF
#exit
#fi

#sfdisk --force -uM ${node} << EOF
#,${boot_rom_sizeb},c
#,${rootfs_size},83
#EOF

# adjust the partition reserve for bootloader.
# if you don't put the uboot on same device, you can remove the BOOTLOADER_ERSERVE
# to have 8M space.
# the minimal sylinder for some card is 4M, maybe some was 8M
# just 8M for some big eMMC 's sylinder
#sfdisk --force -uM ${node} -N1 << EOF
#${BOOTLOAD_RESERVE},${BOOT_ROM_SIZE},c
#EOF

sync
sleep 5

# format the SDCARD/DATA/CACHE partition
part=""
echo ${node} | grep mmcblk > /dev/null
if [ "$?" -eq "0" ]; then
	part="p"
fi


format_yocto
flash_yocto

echo "umount ..."
sync
umount /tmp/media/mmcblk1p1
umount /tmp/media/mmcblk1p2
mount | grep mmcblk1   

read -p "Yocto Flashed. Press any key to continue... " -n1 -s


