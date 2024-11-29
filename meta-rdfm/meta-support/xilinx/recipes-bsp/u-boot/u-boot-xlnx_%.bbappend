include recipes-bsp/u-boot/u-boot-rdfm.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://0003-Integration-of-Mender-boot-code-into-U-Boot-xlnx.patch \
    file://xilinx.cfg \
"
