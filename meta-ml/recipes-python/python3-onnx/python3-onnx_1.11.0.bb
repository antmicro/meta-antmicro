SUMMARY = "ONNX"
DESCRIPTION = "Open Neural Network Exchange (ONNX) is an open ecosystem that empowers AI developers to choose the right tools as their project evolves. ONNX provides an open source format for AI models, both deep learning and traditional ML. It defines an extensible computation graph model, as well as definitions of built-in operators and standard data types. Currently we focus on the capabilities needed for inferencing (scoring)."
HOMEPAGE = "https://github.com/onnx/onnx"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRC_URI = "git://github.com/onnx/onnx.git;protocol=https;branch=main;"
SRC_URI[sha256sum] = "eca224c7c2c8ee4072a0743e4898a84a9bdf8297b5e5910a2632e4c4182ffb2a"
SRCREV = "cf6dfad9a770e4d6412ea88f1833c8e0118e163d"

inherit cmake

DEPENDS += " \
    protobuf \
    python3-protobuf \
    python3-protobuf-native \
    python3-numpy \
    python3-numpy-native \
    python3-typing-extensions-native \
    python3-pybind11-native \
"

RDEPENDS_${PN} += " \
    python3-numpy \
    python3-protobuf \
    python3-typing-extensions \
"

S = "${WORKDIR}/git"
FILES_${PN} += " \
    ${libdir}/libonnxifi*.so \
    ${libdir}/libonnxifi_dummy*.so \
"
FILES_SOLIBSDEV = "${includedir}"

EXTRA_OECMAKE += " \
    -DONNX_USE_PROTOBUF_SHARED_LIBS=ON \
    -BUILD_ONNX_PYTHON=ON \
"
