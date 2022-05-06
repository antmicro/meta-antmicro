SUMMARY = "A Python binding for the v4l2 (video4linux2) userspace api"
HOMEPAGE = "https://github.com/antmicro/python3-v4l2"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=751419260aa954499f7abaabaa882bbe"

SRCREV = "e56ee8574b6dc15f305f23fb872f2038eccf715a"
SRC_URI = " \
    git://github.com/antmicro/python3-v4l2.git;protocol=https;branch=master \
"

S = "${WORKDIR}/git"

RDEPENDS:${PN} = "v4l-utils"

inherit setuptools3
