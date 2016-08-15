#!/bin/bash

# partition size in MB
BOOTLOAD_RESERVE=8
BOOT_ROM_SIZE=20
SPARE_SIZE=400

function format_yocto
{
    echo "formating yocto partitions"
    echo "=========================="
    mkfs.vfat ${node}${part}1 -nBOT-DART6UL
    mkfs.ext4 ${node}${part}2 -Lrootfs
}

function flash_yocto
{
    echo "flashing yocto "
    echo "==============="
    mkdir -p /tmp/BOT-DART6UL
    mkdir -p /tmp/rootfs
    sync
    ls -l /tmp/BOT-DART6UL
    ls -l /tmp/rootfs

    echo "flashing U-BOOT ${node}${part} ..."    
    echo "----------------------------------"
    sudo dd if=tmp/deploy/images/imx6ul-var-dart/SPL-sd of=${node} bs=1K seek=1; sync
    sudo dd if=tmp/deploy/images/imx6ul-var-dart/u-boot-sd-2015.10-r0.img of=${node} bs=1K seek=69; sync

    echo "flashing Yocto BOOT partition ${node}${part}1 ..."    
    echo "-------------------------------------------------"
    sync
    mount ${node}${part}1  /tmp/BOT-DART6UL
    cp tmp/deploy/images/imx6ul-var-dart/zImage-imx6ul-var-dart-emmc_wifi.dtb	/tmp/BOT-DART6UL/imx6ul-var-dart-emmc_wifi.dtb
    cp tmp/deploy/images/imx6ul-var-dart/zImage-imx6ul-var-dart-nand_wifi.dtb	/tmp/BOT-DART6UL/imx6ul-var-dart-nand_wifi.dtb
    cp tmp/deploy/images/imx6ul-var-dart/zImage-imx6ul-var-dart-sd_emmc.dtb	/tmp/BOT-DART6UL/imx6ul-var-dart-sd_emmc.dtb
    cp tmp/deploy/images/imx6ul-var-dart/zImage-imx6ul-var-dart-sd_nand.dtb	/tmp/BOT-DART6UL/imx6ul-var-dart-sd_nand.dtb
    cp tmp/deploy/images/imx6ul-var-dart/zImage					/tmp/BOT-DART6UL/zImage

    echo "flashing Yocto Root file System ${node}${part}2 ..."    
    echo "---------------------------------------------------"
    sync
    mount ${node}${part}2  /tmp/rootfs
    tar xvpf tmp/deploy/images/imx6ul-var-dart/fsl-image-gui-imx6ul-var-dart.tar.bz2 -C /tmp/rootfs/ 2>&1 |
    while read line; do
        x=$((x+1))
        echo -en "$x extracted\r"
    done


}

function copy_yocto
{
sudo mkdir -p /tmp/rootfs/opt
sudo mkdir -p /tmp/rootfs/opt/images
sudo mkdir -p /tmp/rootfs/opt/images/Yocto
#
echo "Copying Fido V01 /opt/images/Yocto..."
echo "-------------------------------------"
sudo cp tmp/deploy/images/imx6ul-var-dart/zImage 					/tmp/rootfs/opt/images/Yocto
sudo cp tmp/deploy/images/imx6ul-var-dart/fsl-image-gui-imx6ul-var-dart.tar.bz2 	/tmp/rootfs/opt/images/Yocto/rootfs.tar.bz2
sudo cp tmp/deploy/images/imx6ul-var-dart/fsl-image-gui-imx6ul-var-dart.ubi 		/tmp/rootfs/opt/images/Yocto/rootfs.ubi.img
sudo cp tmp/deploy/images/imx6ul-var-dart/fsl-image-gui-imx6ul-var-dart.sdcard 		/tmp/rootfs/opt/images/Yocto/rootfs.sdcard
#
sudo cp tmp/deploy/images/imx6ul-var-dart/zImage-imx6ul-var-dart-emmc_wifi.dtb 		/tmp/rootfs/opt/images/Yocto/
sudo cp tmp/deploy/images/imx6ul-var-dart/zImage-imx6ul-var-dart-nand_wifi.dtb		/tmp/rootfs/opt/images/Yocto/
sudo cp tmp/deploy/images/imx6ul-var-dart/zImage-imx6ul-var-dart-sd_emmc.dtb 		/tmp/rootfs/opt/images/Yocto/
sudo cp tmp/deploy/images/imx6ul-var-dart/zImage-imx6ul-var-dart-sd_nand.dtb 		/tmp/rootfs/opt/images/Yocto/
echo "nand u-boot..."
sudo cp tmp/deploy/images/imx6ul-var-dart/SPL-nand					/tmp/rootfs/opt/images/Yocto/
sudo cp tmp/deploy/images/imx6ul-var-dart/u-boot-nand-2015.10-r0.img			/tmp/rootfs/opt/images/Yocto/
echo "sd u-boot..."
sudo cp tmp/deploy/images/imx6ul-var-dart/SPL-sd					/tmp/rootfs/opt/images/Yocto/
sudo cp tmp/deploy/images/imx6ul-var-dart/u-boot-sd-2015.10-r0.img			/tmp/rootfs/opt/images/Yocto/
}

function copy_scripts
{
echo "scripts..."
sudo cp  ../sources/meta-variscite-mx6ul-mx7/scripts/var_mk_yocto_sdcard/variscite_scripts/nand-recovery.sh 	/tmp/rootfs/sbin/
sudo cp  ../sources/meta-variscite-mx6ul-mx7/scripts/var_mk_yocto_sdcard/variscite_scripts/yocto-nand.sh    	/tmp/rootfs/sbin/
sudo cp  ../sources/meta-variscite-mx6ul-mx7/scripts/var_mk_yocto_sdcard/variscite_scripts/yocto-emmc.sh     /tmp/rootfs/sbin/
#
sudo cp  tmp/work/cortexa7hf-vfp-neon-poky-linux-gnueabi/e2fsprogs/1.42.9-r0/image/sbin/e2label 	/tmp/rootfs/sbin
sudo cp  tmp/work/cortexa7hf-vfp-neon-poky-linux-gnueabi/util-linux/2.25.2-r1/build/sfdisk 		/tmp/rootfs/sbin/
#
echo "desktop icons..."
sudo cp ../sources/meta-variscite-mx6ul-mx7/scripts/var_mk_yocto_sdcard/variscite_scripts/*.desktop      	/tmp/rootfs/usr/share/applications/ 
sudo cp ../sources/meta-variscite-mx6ul-mx7/scripts/var_mk_yocto_sdcard/variscite_scripts/terminal*      	/tmp/rootfs/usr/bin
}

echo "Variscite Make Yocto Fido SDCARD utility version 02 DART-6UL version"
echo "====================================================================="


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
node="na"
cal_only=0


while [ "$moreoptions" = 1 -a $# -gt 0 ]; do
	case $1 in
	    -h) help; exit ;;
	    -s) cal_only=1 ;;
	    *)  moreoptions=0; node=$1 ;;
	esac
	[ "$moreoptions" = 0 ] && [ $# -gt 1 ] && help && exit
	[ "$moreoptions" = 1 ] && shift
done

if [ ! -e ${node} ]; then
	help
	exit
fi

part=""
echo ${node} | grep mmcblk > /dev/null
if [ "$?" -eq "0" ]; then
	part="p"
fi

umount ${node}*
fdisk ${node} >/dev/null >>/dev/null <<EOF 
d
1
d
2
d
3
d
w
EOF

# call sfdisk to create partition table
# get total card size
seprate=40
total_size=`sfdisk -s ${node}`
total_size=`expr ${total_size} / 1024`
boot_rom_sizeb=`expr ${BOOT_ROM_SIZE} + ${BOOTLOAD_RESERVE}`
rootfs_size=`expr ${total_size} - ${boot_rom_sizeb} - ${SPARE_SIZE} + ${seprate}`

# create partitions
if [ "${cal_only}" -eq "1" ]; then
cat << EOF
BOOT   : ${boot_rom_sizeb}MB
ROOT   : ${rootfs_size}MB
EOF
exit
fi

# destroy the partition table
dd if=/dev/zero of=${node} bs=1024 count=1
sync
#
# Create new partition table
# We limit the size to less than 4GB
#
fdisk /${node} <<EOF 
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
7500000
p
w
EOF

# format the SDCARD/DATA/CACHE partition
part=""
echo ${node} | grep mmcblk > /dev/null
if [ "$?" -eq "0" ]; then
	part="p"
fi

format_yocto
flash_yocto
copy_yocto
copy_scripts

echo "umount ..."
sync
sudo umount /tmp/BOT-DART6UL
sudo umount /tmp/rootfs
sudo rm -rf /tmp/BOT-DART6UL
sudo rm -rf /tmp/rootfs

