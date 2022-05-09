DESCRIPTION = "Darknet - a C++ deep learning framework, containing YOLO object detection algorithms"

LICENSE = "YOLO-License"
LIC_FILES_CHKSUM = "file://LICENSE;md5=4714f70f7f315d04508e3fd63d9b9232"

SRCREV = "1be96802a030ae2216c7e19b7523e1e2f0948aaf"
SRC_URI = " \
    git://github.com/AlexeyAB/darknet.git;protocol=https;branch=master \
    file://0001-CMakeLists.txt-patched-by-locations-and-stb-line.patch \
"

SRC_URI[sha256sum] = "47344ae4dc9739256bf362a21be864060ab4e2638ffcdef063f6aefe1523c35d"
S = "${WORKDIR}/git"

SECURITY_STRINGFORMAT = ""

inherit cmake pkgconfig

DEPENDS += " \
    opencv \
"

RDEPENDS:${PN} += " \
    opencv \
"

FILES:${PN}-dev = "${includedir}/"

FILES:${PN} += " \
    ${libdir}/libdarknet.so \
    ${bindir}/darknet \
"

