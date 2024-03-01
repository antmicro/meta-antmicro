SUMMARY = "RDFM Tegra slot switching tools"
DESCRIPTION = "Wrapper for RDFM boot environment helpers to allow switching slots on Tegra platforms"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    file://tegra-fw-tools.py \
"

do_install() {
    install -d ${D}${sbindir}/
    install -m 755 ${WORKDIR}/tegra-fw-tools.py ${D}${sbindir}/rdfm-tegra-printenv
    install -m 755 ${WORKDIR}/tegra-fw-tools.py ${D}${sbindir}/rdfm-tegra-setenv
}
