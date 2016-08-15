
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/:"

SRC_URI_append_mx6ul = " file://default.pa"
SRC_URI_append_mx7 = " file://default.pa"

do_install_append() {
    if [ -e "${WORKDIR}/default.pa" ]; then
        install -m 0644 ${WORKDIR}/default.pa ${D}${sysconfdir}/pulse/default.pa
    fi
}

PACKAGE_ARCH_mx6ul = "${MACHINE_SOCARCH}"
PACKAGE_ARCH_mx7 = "${MACHINE_SOCARCH}"
