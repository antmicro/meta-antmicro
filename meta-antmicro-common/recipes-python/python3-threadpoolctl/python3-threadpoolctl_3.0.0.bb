SUMMARY = "Thread-pool Controls"
DESCRIPTION = "Python helpers to limit the number of threads used in the threadpool-backed of common native libraries used for scientific computing and data science (e.g. BLAS and OpenMP)."
HOMEPAGE = "https://github.com/joblib/threadpoolctl"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8f2439cfddfbeebdb5cac3ae4ae80eaf"

inherit setuptools3 pypi
PYPI_PACKAGE = "threadpoolctl"

SRC_URI[md5sum] = "7ea59df7897f267528e9254552ab004c"
SRC_URI[sha256sum] = "d03115321233d0be715f0d3a5ad1d6c065fe425ddc2d671ca8e45e9fd5d7a52a"
