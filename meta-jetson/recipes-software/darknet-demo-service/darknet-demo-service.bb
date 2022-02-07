DESCRIPTION = "Service for darknet demo"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "\
    file://darknet-demo.init \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${S}/darknet-demo.init ${D}${sysconfdir}/init.d/darknet-demo
}

inherit update-rc.d
INITSCRIPT_NAME = "darknet-demo"
RDEPENDS_${PN} = "darknet-demo maxpower"
