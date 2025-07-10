include recipes-bsp/u-boot/u-boot-rdfm.inc

SRC_URI:remove:renodeunmatched = " \
    file://0001-unmatched-integrate-rdfm.patch \
"
SRC_URI:remove:unmatched = " \
    file://0001-unmatched-integrate-rdfm.patch \
"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:renodeunmatched = " \
    file://0003-Integration-of-Mender-boot-code-into-U-Boot-unmatched.patch \
    file://renodeunmatched-integrate-rdfm.cfg \
"

SRC_URI:append:unmatched = " \
    file://0003-Integration-of-Mender-boot-code-into-U-Boot-unmatched.patch \
    file://unmatched-integrate-rdfm.cfg \
"

COMPATIBLE_MACHINE:append = "|(renodeunmatched)"
RPROVIDES:${PN} += "u-boot-env"
