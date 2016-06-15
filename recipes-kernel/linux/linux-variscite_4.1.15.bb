#
#@DESCRIPTION: Linux for Variscite i.MX6ul Dart
#@MAINTAINER: Ron Donio <ron.d@variscite.com>
#
# http://www.variscite.com
# support@variscite.com
#
require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

#SRCBRANCH = "imx-rel_imx_4.1.15_1.1.0_ga-var02"

## dbg ##
SRCBRANCH = "my_work_imx-rel_imx_4.1.15_1.1.0_ga-var02"
KERNEL_SRC = "git://10.54.4.61/kernel;protocol=git"

LOCALVERSION = "-6UL"
SRCREV = "${AUTOREV}"
KERNEL_SRC ?= "git://github.com/varigit/linux-2.6-imx.git;protocol=git"
SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH}"
#LOCALVERSION = "-1.1.0"

FSL_KERNEL_DEFCONFIG = "imx6ul-var-dart_defconfig"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

DEFAULT_PREFERENCE = "1"

addtask copy_defconfig after do_unpack before do_configure
do_copy_defconfig () {
    # copy latest imx_v7_defconfig to use
    cp ${S}/arch/arm/configs/imx6ul-var-dart_defconfig ${B}/.config
    cp ${S}/arch/arm/configs/imx6ul-var-dart_defconfig ${B}/../defconfig
}

# Copy the config file required by ti-compat-wirless-wl18xx
do_deploy_append () {
   cp ${S}/arch/arm/configs/imx6ul-var-dart_defconfig ${S}/.config
}

COMPATIBLE_MACHINE = "(mx6|mx6ul|imx6ul-var-dart)"


