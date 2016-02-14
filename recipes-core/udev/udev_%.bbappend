#Variscite 6UL
#Set the touch to Focaltech

# Change From:
#   SUBSYSTEM=="input", KERNEL=="event[0-9]*", ENV{ID_INPUT_TOUCHSCREEN}=="1", SYMLINK+="input/touchscreen0"
#To:
#   SUBSYSTEM=="input", KERNEL=="event[0-9]*", ATTRS{name}=="ft5x06_ts", SYMLINK+="input/touchscreen0"
#
do_configure_append () {
	sed -i 's/ENV{ID_INPUT_TOUCHSCREEN}=="1"/ATTRS{name}=="ft5x06_ts"/g' ${WORKDIR}/local.rules
}


