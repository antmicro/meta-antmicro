SUMMARY = "Thread-pool Controls"
DESCRIPTION = "Python helpers to limit the number of threads used in the threadpool-backed of common native libraries used for scientific computing and data science (e.g. BLAS and OpenMP)."
HOMEPAGE = "https://github.com/joblib/threadpoolctl"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8f2439cfddfbeebdb5cac3ae4ae80eaf"

inherit setuptools3 pypi
PYPI_PACKAGE = "threadpoolctl"

SRC_URI[md5sum] = "7ea59df7897f267528e9254552ab004c"
SRC_URI[sha256sum] = "d03115321233d0be715f0d3a5ad1d6c065fe425ddc2d671ca8e45e9fd5d7a52a"

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
