FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

include ${@mender_feature_is_enabled("mender-uboot","u-boot-rdfm.inc","",d)}

SRC_URI:append:unmatched = " \
    file://0001-unmatched-integrate-rdfm.patch \
    file://unmatched.cfg \
"
