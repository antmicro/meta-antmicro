FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://0001-Prevent-crash-when-nvpmodel-power-mode-not-set.patch \
    file://jtop.init \
"

inherit update-rc.d

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/jtop.init ${D}${sysconfdir}/init.d/jtop
}

INITSCRIPT_NAME = "jtop"
INITSCRIPT_PARAMS = "defaults 95"

FILES:${PN} += " \
    ${sysconfdir}/init.d/jtop \
"

RDEPENDS:${PN}:append = " \
    util-linux-swaponoff \
"
