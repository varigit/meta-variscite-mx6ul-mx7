#!/bin/sh
#
# Nand recovery version 01. Support Yocto V01 for DART-6UL

MEDIA=/opt/images

OS=Yocto
FLASH=Nand

#UBOOT_IMAGE=u-boot.img
#SPL_IMAGE=SPL
#
KERNEL_IMAGE=zImage
ROOTFS_IMAGE=rootfs.ubi.img
KERNEL_DTB=imx6q-var-som.dtb
#
ANDROID_BOOT=boot.img
ANDROID_RECOVERY=recovery.img
ANDROID_SYSTEM=android_root.img
UBI_SUB_PAGE_SIZE=2048
UBI_VID_HDR_OFFSET=2048

#Creating 5 MTD partitions on "gpmi-nand":
#0x000000000000-0x000000200000 : "spl"
#0x000000200000-0x000000400000 : "uboot"
#0x000000400000-0x000000600000 : "uboot-env"
#0x000000600000-0x000000e00000 : "kernel"
#0x000000e00000-0x000040000000 : "rootfs"

install_bootloader()
{
	if [ ! -f $MEDIA/$OS/$UBOOT_IMAGE ]
	then
		echo "\"$MEDIA/$OS/$UBOOT_IMAGE\"" does not exist! exit.
		exit 1
	fi	

	echo "Installing U-BOOT from \"$MEDIA/$OS/$UBOOT_IMAGE\"..."
	#Flash to NAND	
	flash_erase /dev/mtd0 0 0 2>/dev/null
	kobs-ng init -x $MEDIA/$OS/$SPL_IMAGE --search_exponent=1 -v > /dev/null
	flash_erase /dev/mtd1 0 0 2>/dev/null
	nandwrite -p /dev/mtd1 $MEDIA/$OS/$UBOOT_IMAGE;sync
	flash_erase /dev/mtd2 0 0 2>/dev/null
}

install_kernel()
{
	if [ ! -f $MEDIA/$OS/$KERNEL_IMAGE ]
	then
		echo "\"$MEDIA/$OS/$KERNEL_IMAGE\"" does not exist! exit.
		exit 1
	fi	
	echo "Installing Kernel ..."
	flash_erase  /dev/mtd3 0 0 2>/dev/null
	nandwrite -p /dev/mtd3 $MEDIA/$OS/$KERNEL_IMAGE > /dev/null
	nandwrite -p /dev/mtd3 -s 0x7e0000 $MEDIA/$OS/$KERNEL_DTB > /dev/null
}

install_rootfs()
{
	if [ ! -f $MEDIA/$OS/$ROOTFS_IMAGE ]
	then
		echo "\"$MEDIA/$OS/$ROOTFS_IMAGE\"" does not exist! exit.
		exit 1
	fi	
	echo "Installing UBI rootfs ..."
	flash_erase /dev/mtd4 0 0 3>/dev/null
	ubiformat /dev/mtd4 -f $MEDIA/$OS/$ROOTFS_IMAGE -s $UBI_SUB_PAGE_SIZE -O $UBI_VID_HDR_OFFSET
}

                                                                          
usage()
{
	cat << EOF
		usage: $0 options

		This script install Android(KitKat 443_200)/Yocto V8(Daisy) binaries in VAR-SOM-MX6 NAND or eMMC.

		OPTIONS:
		-h                       Show this message
		-o <Yocto>               OS type (defualt: Yocto).
		-m <Nand|Emmc>  	 Media type (defualt: Nand).

EOF
}

while getopts :h:o:m: OPTION;
do
	case $OPTION in
	h)
		usage
		exit 1
		;;
	o)
		OS=$OPTARG
		;;
	m)
		FLASH=$OPTARG
		;;

	?)
		usage
		exit 1
	;;
	esac
done

if [[ "$OS" != "Yocto" ]]
then
	usage
	exit 1
fi

if [[ "$FLASH" != "Nand" ]] && [[ "$FLASH" != "Emmc" ]] 
then
	usage
	exit 1
fi


if [ `dmesg |grep UltraLite | wc -l` = 1 ] ; then
	echo "================================================"
	echo " nand-recovery Variscite i.MX6 UltraLite DART   "
	echo "================================================"
else
	echo "================================================"
	echo " nand-recovery is only compatible with DART-6UL."
	echo "================================================"
	read -p "Press any key to continue... " -n1 -s
	exit 0
fi

SPL_IMAGE=SPL-nand
UBOOT_IMAGE=u-boot-nand-2015.04-r0.img
KERNEL_DTB=zImage-imx6ul-var-dart-nand_wifi.dtb
echo "**********************************************"
echo "*** DART-6UL eMMC/nand RECOVERY Version 01 ***"
echo "*** Installing $OS on $FLASH               ***"
echo "*** Using $KERNEL_DTB Device tree          ***"
echo "**********************************************"

install_bootloader
install_kernel
install_rootfs


exit 0
