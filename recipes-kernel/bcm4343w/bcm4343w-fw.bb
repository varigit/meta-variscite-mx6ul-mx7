DESCRIPTION = "Firmware files for use with BCM4343w wifi"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENCE.broadcom_bcm4343w;md5=3160c14df7228891b868060e1951dfbc"

inherit allarch

PV = "6.20.190"
PR = "r2"

PROVIDES += "bcm4343w-fw"


SRC_URI = "git://github.com/varigit/bcm_4343w_fw.git;protocol=git;branch=master"
SRCREV = "79204a8a687d723bab1db2c5f502b74a299a37fc"

S = "${WORKDIR}/git"

do_compile() {
    :
}


do_install() {
        install -d  ${D}/lib/firmware
	install -m 0755 ${WORKDIR}/git/bcmdhd.cal ${D}/lib/firmware/bcmdhd.cal
	install -m 0755 ${WORKDIR}/git/fw_bcmdhd.bin ${D}/lib/firmware/fw_bcmdhd.bin
	install -m 0755 ${WORKDIR}/git/fw_bcmdhd_mfgtest.bin ${D}/lib/firmware/fw_bcmdhd_mfgtest.bin
        install -m 0755 ${WORKDIR}/git/LICENCE.broadcom_bcm4343w ${D}/lib/firmware/
}

FILES_${PN} = "/lib/firmware/*"
