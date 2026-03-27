SUMMARY = "A plugin for pytest that shows failures and errors instantly instead of waiting until the end of test session."
HOMEPAGE = "https://github.com/pytest-dev/pytest-instafail"
AUTHOR = "Janne Vanhala"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=cfcfe2df68bfe72ab8c9db8876dd665f"

inherit pypi setuptools3

SRC_URI[sha256sum] = "33a606f7e0c8e646dc3bfee0d5e3a4b7b78ef7c36168cfa1f3d93af7ca706c9e"

RDEPENDS:${PN} += " \
    python3-pytest \
"
