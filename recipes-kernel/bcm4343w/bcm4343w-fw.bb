DESCRIPTION = "Firmware files for use with BCM4343w wifi"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENCE.broadcom_bcm4343w;md5=3160c14df7228891b868060e1951dfbc"

inherit allarch

PV = "6.20.190"
PR = "r2"

PROVIDES += "bcm4343w-fw"


SRC_URI = "git://github.com/varigit/bcm_4343w_fw.git;protocol=git;branch=master"
SRCREV = "40e59e6a00ca169a3b722a6085513a6e261664c5"

S = "${WORKDIR}/git"

do_compile() {
    :
}


do_install() {
        install -d  ${D}/lib/firmware/bcm
	install -m 0755 ${WORKDIR}/git/bcmdhd.cal ${D}/lib/firmware/bcm/bcmdhd.cal
	install -m 0755 ${WORKDIR}/git/bcm43430a1.hcd ${D}/lib/firmware/bcm/bcm43430a1.hcd
	install -m 0755 ${WORKDIR}/git/fw_bcmdhd.bin ${D}/lib/firmware/bcm/fw_bcmdhd.bin
	install -m 0755 ${WORKDIR}/git/fw_bcmdhd_mfgtest.bin ${D}/lib/firmware/bcm/fw_bcmdhd_mfgtest.bin
	install -m 0755 ${WORKDIR}/git/fw_bcmdhd_apsta.bin ${D}/lib/firmware/bcm/fw_bcmdhd_apsta.bin
        install -m 0755 ${WORKDIR}/git/LICENCE.broadcom_bcm4343w ${D}/lib/firmware/bcm/
#        install -d ${D}${bindir}/
#	install -m 0755 ${WORKDIR}/git/wl ${D}/usr/sbin/wl
}

FILES_${PN} = "/lib/firmware/bcm/*"
