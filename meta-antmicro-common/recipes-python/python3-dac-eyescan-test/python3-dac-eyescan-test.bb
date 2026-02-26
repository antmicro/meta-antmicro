SUMMARY = "Connect to the DAC38J8x using JTAG and perform eyescan test"
HOMEPAGE = "https://github.com/antmicro/dac-eyescan-test"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/antmicro/dac-eyescan-test.git;branch=main;protocol=https"
SRCREV = "9e49c224c6a034d31217a92fd6f861710798ca63"

S = "${WORKDIR}/git"

RDEPENDS:${PN} = " python3-pyftdi "
DEPENDS += " python3-setuptools-scm-native "

inherit python_setuptools_build_meta
