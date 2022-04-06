SUMMARY = "ONNX"
DESCRIPTION = "Open Neural Network Exchange (ONNX) is an open ecosystem that empowers AI developers to choose the right tools as their project evolves. ONNX provides an open source format for AI models, both deep learning and traditional ML. It defines an extensible computation graph model, as well as definitions of built-in operators and standard data types. Currently we focus on the capabilities needed for inferencing (scoring)."
HOMEPAGE = "https://github.com/onnx/onnx"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRC_URI = " \
            git://github.com/onnx/onnx.git;protocol=https;branch=main; \
            file://0001-Removed-hardcoded-protobuf-pathes.patch \
            file://0001-Removed-inbuilt-cmake-package-building.patch \
            file://0001-CMake-build-directory-specified-by-enviroment-variab.patch \
"
SRC_URI[sha256sum] = "eca224c7c2c8ee4072a0743e4898a84a9bdf8297b5e5910a2632e4c4182ffb2a"
SRCREV = "cf6dfad9a770e4d6412ea88f1833c8e0118e163d"

inherit cmake python3native

DEPENDS += " \
    python3-native \
    python3 \
    protobuf \
    protobuf-native \
    python3-pytest-runner-native \
    cmake-native \
    python3-pybind11-native \
"

RDEPENDS_${PN} += " \
    python3-numpy \
    protobuf \
    python3-protobuf \
    python3-typing-extensions \
"

S = "${WORKDIR}/git"
FILES_${PN} += " \
    ${libdir}/libonnxifi*.so \
"
FILES_SOLIBSDEV = "${includedir}"

OECMAKE_GENERATOR = "Unix Makefiles"
EXTRA_OECMAKE += " \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DONNX_NAMESPACE=onnx \
    -DPYTHON_INCLUDE_DIR=${STAGING_DIR_TARGET}/usr/include/python3.9 \
    -DPY_EXT_SUFFIX=.cpython-39-aarch64-linux-gnu.so \
    -DONNX_CUSTOM_PROTOC_EXECUTABLE=${STAGING_DIR_NATIVE}${prefix}/bin/protoc \
    -DONNX_USE_PROTOBUF_SHARED_LIBS=ON \
    -DBUILD_ONNX_PYTHON:BOOL=ON \
"
do_compile_append() {
    cd ${S}
    export CMAKE_BUILD_DIR=${B}

    STAGING_INCDIR=${STAGING_INCDIR} \
    STAGING_LIBDIR=${STAGING_LIBDIR} \
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} setup.py \
    build || \
    bbfatal_log "'${PYTHON_PN} setup.py buildk' execution failed."
}

do_install() {
    cd ${S}
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}
    STAGING_INCDIR=${STAGING_INCDIR} \
    STAGING_LIBDIR=${STAGING_LIBDIR} \
    PYTHONPATH=${D}${PYTHON_SITEPACKAGES_DIR} \
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-NATIVE/${PYTHON_PN} setup.py install {DISTUTILS_INSTALL_ARGS} || \
    bbfatal_log "'${PYTHON_PN} setup.py install ${DISTUTILS_INSTALL_ARGS}' execution failed."
}
