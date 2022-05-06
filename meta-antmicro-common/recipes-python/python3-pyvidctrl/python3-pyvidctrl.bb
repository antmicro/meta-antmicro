SUMMARY = "A small Python utility for controlling video4linux cameras"
HOMEPAGE = "https://github.com/antmicro/pyvidctrl"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRCREV = "7b161c7ef605e37c91a711f37c97451c5a1385f4"
SRC_URI = " \
    git://github.com/antmicro/pyvidctrl.git;protocol=https;branch=master \
"

S = "${WORKDIR}/git"

RDEPENDS:${PN} = "python3-v4l2"

inherit setuptools3
