DESCRIPTION = "RDFM artifact provides"
HOMEPAGE = "https://antmicro.com/"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

S = "${WORKDIR}"

inherit allarch

PV = "0.1"

do_compile() {
    touch ${B}/provides_info
}

do_install() {
    install -d ${D}${sysconfdir}/mender
    install -m 0644 -t ${D}${sysconfdir}/mender ${B}/provides_info
}

FILES:${PN} += " \
    ${sysconfdir}/mender/provides_info \
"
