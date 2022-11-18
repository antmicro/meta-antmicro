SUMMARY = "An automated framework for platform testing (Hardware and BSPs)"
HOMEPAGE = "https://github.com/antmicro/protoplaster"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI = " \
    git://github.com/antmicro/protoplaster.git;protocol=https;branch=main \
"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

RDEPENDS:${PN} = " \
    python3-smbus2 \
    python3-pytest \
    python3-pyrav4l2 \
    python3-pyyaml \
    python3-colorama \
"

inherit setuptools3
