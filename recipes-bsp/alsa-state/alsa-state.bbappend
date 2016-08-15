# As it can not overwrite the version in the layer meta-fsl-arm, we have to use
#   another file extension for new patch to the append in the meta-fsl-arm

# Append path for freescale layer to include alsa-state asound.conf
FILESEXTRAPATHS_prepend_mx6ul := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend_mx7 := "${THISDIR}/${PN}:"
