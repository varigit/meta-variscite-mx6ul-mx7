#@DESCRIPTION: Linux for Variscite DART-6UL / VAR-SOM-MX7
#
# http://www.variscite.com
# support@variscite.com

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH_mx6ul = "imx-rel_imx_4.1.15_1.1.0_ga-var02"
SRCBRANCH_mx7 = "imx-rel_imx_4.1.15_1.2.0_ga-var01"

LOCALVERSION_mx6ul = "-6UL"
LOCALVERSION_mx7 = "-7Dual"
SRCREV = "${AUTOREV}"
KERNEL_SRC ?= "git://github.com/varigit/linux-2.6-imx.git;protocol=git"
SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH} \
           file://0001-compiler-gcc-integrate-the-various-compiler-gcc-345-.patch \
           file://Fix-gcc6-build-error-in-Vivante-driver.patch \
"
#LOCALVERSION = "-1.1.0"

FSL_KERNEL_DEFCONFIG_mx6ul = "imx6ul-var-dart_defconfig"
FSL_KERNEL_DEFCONFIG_mx7 = "imx7-var-som_defconfig"
KERNEL_DEFCONFIG_mx6ul = "imx6ul-var-dart_defconfig"
KERNEL_DEFCONFIG_mx7 = "imx7-var-som_defconfig"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

DEFAULT_PREFERENCE = "1"

addtask copy_defconfig after do_unpack before do_preconfigure
do_copy_defconfig () {
    # copy latest imx_v7_defconfig to use
    cp ${S}/arch/arm/configs/${FSL_KERNEL_DEFCONFIG} ${B}/.config
    cp ${S}/arch/arm/configs/${FSL_KERNEL_DEFCONFIG} ${B}/../defconfig
}

COMPATIBLE_MACHINE = "(mx6ul|mx7)"
