FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove:mender-uboot = " file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI:append:mender-uboot = " file://0003-Integration-of-Rdfm-boot-code-into-U-Boot.patch"
