# Freescale imx extra configuration udev rules
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_mx6ul = " file://blacklist.conf"

do_install_prepend_mx6ul () {
        if [ -e "${WORKDIR}/blacklist.conf" ]; then
                install -d ${D}${sysconfdir}/modprobe.d
                install -m 0644 ${WORKDIR}/blacklist.conf ${D}${sysconfdir}/modprobe.d
        fi
}

FILES_${PN}_append = " ${sysconfdir}/modprobe.d"
FILES_${PN}_append = " ${sysconfdir}/default/udev-cache"

PACKAGE_ARCH_mx6ul = "${MACHINE_SOCARCH}"

