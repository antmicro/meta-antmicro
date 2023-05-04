DESCRIPTION = "Custom flash layout file to add rdfm-specific partitions"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://flash_rdfm.xml"

INHIBIT_DEFAULT_DEPS = "1"
COMPATIBLE_MACHINE = "(tegra)"

FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${datadir}/rdfm-flash-layout
    install -m 0644 ${S}/flash_rdfm.xml ${D}${datadir}/rdfm-flash-layout/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit nopackages
