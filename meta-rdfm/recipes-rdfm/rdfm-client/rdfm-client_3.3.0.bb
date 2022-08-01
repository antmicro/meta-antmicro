require rdfm-client.inc

SRC_URI = " \
    git://github.com/antmicro/rdfm.git;protocol=https;branch=main;destsuffix=git \
    file://0001-Fix-openssl-Could-not-determine-kind-of-name-for-C.F.patch \
"
SRCREV = "cf28383be07350b3767980d7d9d8386c1dbf2759"
SRCREV[sha256sum] = "92a37d9209c02bd72b32088045424d3a426dfd8d0837f36302fbaee3584e2d41"
SRCREV[md5sum] = "db9b5b9b093f1cd4295ea510a119c3c3"

LICENSE = "Apache-2.0 & BSD-2-Clause & BSD-3-Clause & ISC & MIT & OLDAP-2.8 & OpenSSL"
LIC_FILES_CHKSUM = "file://LIC_FILES_CHKSUM.sha256;md5=69a48b331ae876b6775139310ec72f1b"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

DEPENDS += "xz openssl"
RDEPENDS_${PN} += "liblzma openssl"
