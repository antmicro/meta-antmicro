FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append:mender-uboot:freedom-u540 = " file://0001-Remove-unleashed-mmc.patch"

DEPENDS:remove:freedom-u540 = "opensbi"

do_deploy:append() {
    install -D -m 644 ${B}/u-boot-dtb.bin ${DEPLOYDIR}/
}
