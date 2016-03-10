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

SRCBRANCH = "imx_3.14.38_6ul_ga_dart_var01"
LOCALVERSION = "-6UL"
SRCREV = "e0f466b23b6f1be031442ba90b87a6c49ec129f8"
KERNEL_SRC ?= "git://github.com/varigit/linux-2.6-imx.git;protocol=git"
SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH}"
#LOCALVERSION = "-1.1.0"

FSL_KERNEL_DEFCONFIG = "imx6ul-var-dart_defconfig"

#KERNEL_IMAGETYPE = "uImage"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

do_configure_prepend() {
   # copy latest defconfig for imx_v7_var_defoonfig to use
   cp ${S}/arch/arm/configs/imx6ul-var-dart_defconfig ${B}/.config
   cp ${S}/arch/arm/configs/imx6ul-var-dart_defconfig ${B}/../defconfig
}


# Copy the config file required by ti-compat-wirless-wl18xx
do_deploy_append () {
   cp ${S}/arch/arm/configs/imx6ul-var-dart_defconfig ${S}/.config
}


COMPATIBLE_MACHINE = "(imx6ul-var-dart)"

DEFAULT_PREFERENCE = "1"

