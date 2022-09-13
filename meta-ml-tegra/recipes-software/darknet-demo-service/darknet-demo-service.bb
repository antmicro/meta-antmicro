DESCRIPTION = "Service for darknet demo"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "\
    file://darknet-demo.desktop \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/home/root/.config/autostart
    install ${S}/darknet-demo.desktop ${D}/home/root/.config/autostart/darknet-demo.desktop
}

FILES:${PN} += "/home/root/.config/autostart/darknet-demo.desktop"
RDEPENDS:${PN} = "darknet-imgui-visualization maxpower"
