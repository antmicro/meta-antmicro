FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

include ${@mender_feature_is_enabled("mender-uboot","u-boot-rdfm.inc","",d)}

SRC_URI:append:unmatched = " \
    file://0001-unmatched-integrate-rdfm.patch \
    file://unmatched.cfg \
"

SRC_URI:append:renodeunmatched = " \
    file://0001-unmatched-integrate-rdfm.patch \
    file://9999-renode-Remove-therm-sensor-initialization.patch \
    file://9999-renode-Enable-VirtIO-on-unmatched.patch \
    file://9999-renode-Add-generic-block-device-environment.patch \
    file://renodeunmatched.cfg \
"
