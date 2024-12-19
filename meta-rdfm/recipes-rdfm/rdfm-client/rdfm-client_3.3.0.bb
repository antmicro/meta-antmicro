# Required for fetching Go dependencies
do_compile[network] = "1"

require rdfm-client.inc

SRC_URI = "git://github.com/antmicro/rdfm.git;protocol=https;branch=main;destsuffix=git"
SRCREV = "f8d65ce7085db8c4d026671e5c625b429762a459"

LICENSE = "Apache-2.0 & BSD-2-Clause & BSD-3-Clause & ISC & MIT & OLDAP-2.8 & OpenSSL"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=2a944942e1496af1886903d274dedb13"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

DEPENDS += "xz openssl"
RDEPENDS:${PN} += "liblzma openssl"
RDEPENDS:${PN} += "data-resizefs"
RDEPENDS:${PN} += " ${RDFM_BOOTLOADER} "
