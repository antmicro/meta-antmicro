inherit update-rc.d

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    file://template.sysvinit \
"

INITSCRIPT_PACKAGES ?= "${PN}"
INITSCRIPT_NAME ?= "haveged"
INITSCRIPT_PARAMS:${PN} ?= "defaults 9"

do_install:append () {
    if ${@bb.utils.contains("DISTRO_FEATURES", "sysvinit", "true", "false", d)}; then
        install -Dm 755 ${WORKDIR}/template.sysvinit ${D}${INIT_D_DIR}/${INITSCRIPT_NAME}
    fi
}

FILES:${PN} += "${INIT_D_DIR}/${INITSCRIPT_NAME}"
