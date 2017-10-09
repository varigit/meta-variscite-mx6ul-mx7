# Copyright (C) 2013-2015 Freescale Semiconductor

DESCRIPTION = "U-Boot provided by Freescale with focus on  i.MX reference boards."
require recipes-bsp/u-boot/u-boot.inc

PROVIDES += "u-boot"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRCBRANCH = "imx_v2015.10_dart_6ul_var1"
UBOOT_SRC ?= "git://github.com/varigit/uboot-imx.git;protocol=git;protocol=git"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "570b452d2056ddb8a724f47bc193bfcc55663891"

S = "${WORKDIR}/git"

inherit fsl-u-boot-localversion

LOCALVERSION ?= "-${SRCBRANCH}"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx6|mx7)"
