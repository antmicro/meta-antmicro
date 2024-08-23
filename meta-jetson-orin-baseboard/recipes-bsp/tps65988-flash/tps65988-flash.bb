SUMMARY = "A script which allows flashing TPS65988 configuration for Jetson Orin Baseboard."
HOMEPAGE = "https://github.com/antmicro/antmicro-jetson-orin-baseboard-tps65988-config"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2b42edef8fa55315f34f2370b4715ca9"

SRC_URI = "git://github.com/antmicro/antmicro-jetson-orin-baseboard-tps65988-config.git;protocol=https;branch=main"

SRCREV="${AUTOREV}"

S = "${WORKDIR}/git"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

RDEPENDS:${PN} = " \
    python3-smbus2 \
    perl \
"

do_install() {
    install -d ${D}/opt/antmicro/TPS65988-flash
    cp -r ${WORKDIR}/git/. ${D}/opt/antmicro/TPS65988-flash/
}

FILES:${PN} += "/opt/antmicro/TPS65988-flash/"
