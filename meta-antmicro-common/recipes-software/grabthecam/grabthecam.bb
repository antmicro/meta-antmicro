SUMMARY = "grabthecam"
DESCRIPTION = "A C++ library for controlling video4linux cameras and capturing frames."
HOMEPAGE = "https://github.com/antmicro/grabthecam"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2a944942e1496af1886903d274dedb13"

SRC_URI = " \
    git://github.com/antmicro/grabthecam;protocol=https;branch=main \
"

SRCREV = "ec59861a99d759bcdd54e00ee8af29571d755ddc"

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
