SUMMARY = "synr"
DESCRIPTION = "Synr is a library that provides a stable Abstract Syntax Tree for Python."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327;"

SRC_URI[sha256sum] = "0b4e16b10c3988e1981e3372153a31956f74d86752eaaa55e8c4e7b7fe591e4e"
SRC_URI[md5sum] = "edb7a0da96dad86615566a4cc5575341"

inherit pypi setuptools3

RDEPENDS:{PN} += "python3-attr"
