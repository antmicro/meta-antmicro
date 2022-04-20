SUMMARY = "Apache TVM"
DESCRIPTION = "Apache TVM is a compiler stack for deep learning systems. It is designed to close the gap between the productivity-focused deep learning frameworks, and the performance- and efficiency-focused hardware backends. TVM works with deep learning frameworks to provide end to end compilation to different backends."
HOMEPAGE = "https://tvm.apache.org/"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f30f7a1bcf7728eb568504d96cee7b09;"

SRC_URI += "gitsm://github.com/apache/tvm.git;protocol=https;branch=v0.8;"
SRC_URI[sha256sum] = "7cb6c6563417b64ad0b71abe8899109380c91c0ab8c40cfe3e2569b6fcb6e724" 
SRCREV = "7b3a22e465dd6aca4729504a19beb4bc23312755"
SRC_URI += " \
            file://0001-Adds-a-builddir-to-look-for-libraries.patch \
            file://0001-Removes-all-requirements.patch \
"

S = "${WORKDIR}/git"

inherit cmake python3native

EXTRA_OECMAKE += " \
    -DMACHINE_NAME=${TARGET_SYS} \
    -DUSE_LIBBACKTRACE=OFF \
"

DEPENDS += " \
    python3-setuptools-native \
    python3-attrs \
    python3-cloudpickle \
    python3-decorator \
    python3-numpy \
    python3-psutil \
    python3-scipy \
    python3-synr \
    python3-tornado \
"

RDEPENDS_${PN} += " \
    python3-attrs \
    python3-cloudpickle \
    python3-decorator \
    python3-numpy \
    python3-psutil \
    python3-scipy \
    python3-synr \
    python3-tornado \
"

do_compile_append() {
    cd ${S}/python
    STAGING_INCDIR=${STAGING_INCDIR} \
    STAGING_LIBDIR=${STAGING_LIBDIR} \
    BUILDDIR="${B}" \
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} setup.py \
    build || \
    bbfatal_log "'${PYTHON_PN} setup.py build' execution failed."
}

do_install() {
    cd ${S}/python
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}
    STAGING_INCDIR=${STAGING_INCDIR} \
    STAGING_LIBDIR=${STAGING_LIBDIR} \
    BUILDDIR="${B}" \
    PYTHONPATH=${D}${PYTHON_SITEPACKAGES_DIR} \
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} setup.py install ${DISTUTILS_INSTALL_ARGS} || \
    bbfatal_log "'${PYTHON_PN} setup.py install ${DISTUTILS_INSTALL_ARGS}' execution failed."
}

DISTUTILS_INSTALL_ARGS += "--prefix ${D}/usr"
FILES_${PN} += "${libdir}/*"
OECMAKE_GENERATOR = "Unix Makefiles"
