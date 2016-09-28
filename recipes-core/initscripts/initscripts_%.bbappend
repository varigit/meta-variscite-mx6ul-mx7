FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append			= " file://variscite-bluetooth \
				    file://variscite-pwrkey"

SRC_URI_append_imx7-var-som	= " file://variscite-bluetooth-mx7.patch"

do_install_append() {
	install -m 0755 ${WORKDIR}/variscite-bluetooth ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/variscite-pwrkey ${D}${sysconfdir}/init.d
	update-rc.d -r ${D} variscite-bluetooth start 99 2 3 4 5 .
	update-rc.d -r ${D} variscite-pwrkey start 99 2 3 4 5 .
}
