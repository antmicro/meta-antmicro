DESCRIPTION = "Darknet deep learning framework implementing You Only Look Once object detection algorithm"

LICENSE = "YOLO-License"
LIC_FILES_CHKSUM = "file://LICENSE;md5=4714f70f7f315d04508e3fd63d9b9232"

SRCREV = "1be96802a030ae2216c7e19b7523e1e2f0948aaf"
SRC_URI = " \
    git://github.com/AlexeyAB/darknet.git;protocol=https \
    file://0001-CMakeLists.txt-patched-by-locations-and-stb-line.patch \
"

SRC_URI[sha256sum] = "47344ae4dc9739256bf362a21be864060ab4e2638ffcdef063f6aefe1523c35d"
S = "${WORKDIR}/git"

SECURITY_STRINGFORMAT = ""

inherit cuda cmake pkgconfig

DEPENDS += " \
    cuda-cudart \
    cudnn \
    opencv \
    tegra-libraries \
"

RDEPENDS_${PN} += " \
    cuda-cudart \
    cudnn \
    opencv \
    tegra-libraries \
"

FILES_${PN}-dev = "${includedir}/"

FILES_${PN} += " \
    ${libdir}/libdarknet.so \
    ${bindir}/darknet \
"

