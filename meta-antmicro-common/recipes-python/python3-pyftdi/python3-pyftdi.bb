SUMMARY = "FTDI device driver written in pure Python"
HOMEPAGE = "https://github.com/antmicro/pyftdi"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=594d69e7c7998360f0ae80c8c95c4732"

SRC_URI = " \
    git://github.com/antmicro/pyftdi.git;protocol=https;branch=dac-eyescan-test \
"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

RDEPENDS:${PN} = " \
    python3-pyusb \
    python3-pyserial \
"

inherit setuptools3
