FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append			= " file://variscite-bluetooth"
SRC_URI_append_imx7-var-som	= " file://variscite-bluetooth-mx7.patch"

do_install_append() {
	if [ -e "${WORKDIR}/variscite-bluetooth" ]; then
		install -m 0755    ${WORKDIR}/variscite-bluetooth ${D}${sysconfdir}/init.d
		update-rc.d -r ${D} variscite-bluetooth start 99 2 3 4 5 .
	fi
}
