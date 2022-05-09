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

DISTUTILS_BUILD_ARGS ?= ""
DISTUTILS_INSTALL_ARGS ?= " \
    --root=${D} \
    --prefix=${prefix} \
    --install-lib=${PYTHON_SITEPACKAGES_DIR} \
    --install-data=${datadir} \
"
do_compile() {
    cd ${S}
    NO_FETCH_BUILD=1 \
    STAGING_INCDIR=${STAGING_INCDIR} \
    STAGING_LIBDIR=${STAGING_LIBDIR} \
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} setup.py \
    build --build-base=${B} ${DISTUTILS_BUILD_ARGS} || \
    bbfatal_log "'${PYTHON_PN} setup.py build ${DISTUTILS_BUILD_ARGS}' execution failed."
}

do_install() {
    cd ${S}
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}
    STAGING_INCDIR=${STAGING_INCDIR} \
    STAGING_LIBDIR=${STAGING_LIBDIR} \
    PYTHONPATH=${D}${PYTHON_SITEPACKAGES_DIR} \
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} setup.py \
    build --build-base=${B} install --skip-build ${DISTUTILS_INSTALL_ARGS} || \
    bbfatal_log "'${PYTHON_PN} setup.py install ${DISTUTILS_INSTALL_ARGS}' execution failed."
}
