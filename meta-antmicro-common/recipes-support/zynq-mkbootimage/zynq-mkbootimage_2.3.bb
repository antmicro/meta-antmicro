SUMMARY = "Zynq mkbootimage"
DESCRIPTION = "An open-source replacement for the Xilinx bootgen application"
HOMEPAGE = "https://github.com/antmicro/zynq-mkbootimage"

SRC_URI += "git://github.com/antmicro/zynq-mkbootimage.git;protocol=https;branch=master;md5=96903b5e12eaa74b46b73464799c7f01"
LICENSE = "BSD-2-Clause"
SRCREV = "872363ce32c249f8278cf107bc6d3bdeb38d849f"
LIC_FILES_CHKSUM = "file://LICENSE;md5=0c9c77a4b70683658eb47e5486e20148"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

DEPENDS += " \
    elfutils \
"

EXTRA_OEMAKE += " \
    CFLAGS='-I${STAGING_INCDIR}' \
"

do_compile() {
    mkdir ${B} || cd ${B}
    cp ${S}/* ${B} -r
    oe_runmake all 'CC=${CC}'
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/mkbootimage ${D}${bindir}
    install -m 0755 ${B}/exbootimage ${D}${bindir}
}
