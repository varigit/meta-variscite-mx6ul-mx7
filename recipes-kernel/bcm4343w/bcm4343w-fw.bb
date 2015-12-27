DESCRIPTION = "Firmware files for use with BCM4343w wifi"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENCE.broadcom_bcm4343w;md5=3160c14df7228891b868060e1951dfbc"

inherit allarch

PV = "6.20.190"
PR = "r2"

PROVIDES += "bcm4343w-fw"


SRC_URI = "git://github.com/varigit/bcm_4343w_fw.git;protocol=git;branch=master"
SRCREV = "e91fdebe68b95d3cc8549da7f15665bce2fb5ebf"

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
        install -m 0755 ${WORKDIR}/git/LICENCE.broadcom_bcm4343w ${D}/lib/firmware/bcm/
}

FILES_${PN} = "/lib/firmware/bcm/*"
