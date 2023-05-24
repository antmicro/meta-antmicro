FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://p3767_flashvars"

do_install:append:tegra234() {
    install -d ${D}${datadir}/tegraflash
    install -m 0644 ${S}/p3767_flashvars ${D}${datadir}/tegraflash/flashvars
}
