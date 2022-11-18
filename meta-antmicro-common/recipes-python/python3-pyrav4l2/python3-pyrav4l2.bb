SUMMARY = "Library that lets you easily control V4L2 devices inside python scripts"
HOMEPAGE = "https://github.com/antmicro/pyrav4l2"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = " \
    git://github.com/antmicro/pyrav4l2.git;protocol=https;branch=main \
"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

RDEPENDS:${PN} += "${PYTHON_PN}-mmap"

inherit setuptools3
