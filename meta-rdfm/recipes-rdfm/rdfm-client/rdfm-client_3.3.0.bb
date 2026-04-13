# Required for fetching Go dependencies
do_compile[network] = "1"

require rdfm-client.inc
inherit systemd update-rc.d

SRC_URI = " \
    git://github.com/antmicro/rdfm.git;protocol=https;branch=main;destsuffix=git \
    file://rdfm-daemon.service \
    file://rdfm-daemon \
"
SRCREV = "f74f362decaef348f22dd3da9c8893f52a1452fd"

LICENSE = "Apache-2.0 & BSD-2-Clause & BSD-3-Clause & ISC & MIT & OLDAP-2.8 & OpenSSL"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=2a944942e1496af1886903d274dedb13"

INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME = "rdfm"
INITSCRIPT_PARAMS:${PN} = "defaults 9"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "rdfm.service"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

FILES:${PN} += " \
    ${systemd_unitdir}/system \
    ${sysconfdir}/init.d \
"

DEPENDS += "xz openssl go-xdelta protobuf-native go-protoc-native"
RDEPENDS:${PN} += "liblzma openssl"
RDEPENDS:${PN} += "data-resizefs"
RDEPENDS:${PN} += " ${RDFM_BOOTLOADER} "

do_install:append () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
        install -Dm 0755 ${WORKDIR}/rdfm-daemon ${D}/${sysconfdir}/init.d/rdfm
    fi
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -Dm 0644 ${WORKDIR}/rdfm-daemon.service ${D}/${systemd_unitdir}/system/rdfm.service
    fi
}
