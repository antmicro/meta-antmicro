SUMMARY = "farshow"
DESCRIPTION = "A minimalistic library for streaming and displaying frames from remote devices."
HOMEPAGE = "https://github.com/antmicro/farshow"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2a944942e1496af1886903d274dedb13"

SRC_URI = " \
    gitsm://github.com/antmicro/farshow;protocol=https;branch=main \
"

SRCREV = "d96c63a4dbeb0ecb9480b2fc05922b018e8ea3e5"

inherit cmake

DEPENDS += " \
    opencv \
    glfw \
    glew \
"

RDEPENDS:${PN} += " \
    opencv \
    glfw \
    glew \
"

S = "${WORKDIR}/git"

FILES:${PN} += " \
    ${libdir}/libfarshow-imgui.so \
"

FILES:${PN}-dev = " \
    ${includedir} \
    ${libdir}/cmake/* \
    ${libdir}/libfarshow-connection.so \
"
