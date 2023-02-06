# Required for fetching Go dependencies
do_compile[network] = "1"

require rdfm-client.inc

SRC_URI = "git://github.com/antmicro/rdfm.git;protocol=https;branch=main;destsuffix=git"
SRCREV = "a8fc5c7ec78e18f0b91b4ae9812a09a9f6756c68"

LICENSE = "Apache-2.0 & BSD-2-Clause & BSD-3-Clause & ISC & MIT & OLDAP-2.8 & OpenSSL"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=2a944942e1496af1886903d274dedb13"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

DEPENDS += "xz openssl"
RDEPENDS:${PN} += "liblzma openssl"
