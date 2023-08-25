SUMMARY = "grabthecam"
DESCRIPTION = "A C++ library for controlling video4linux cameras and capturing frames."
HOMEPAGE = "https://github.com/antmicro/grabthecam"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2a944942e1496af1886903d274dedb13"

SRC_URI = " \
    git://github.com/antmicro/grabthecam;protocol=https;branch=main \
"

SRCREV = "79cb58a093fa7de17bb90ee3780b21ab5dd18520"

inherit cmake

DEPENDS += " \
    opencv \
    rapidjson \
    v4l-utils \
"

RDEPENDS:${PN} += " \
    opencv \
    rapidjson \
    v4l-utils \
"

S = "${WORKDIR}/git"
