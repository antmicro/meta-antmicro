# Required for Go dependency fetch
do_compile[network] = "1"

DESCRIPTION = "Recipe responsible for the installation of the RDFM Linux client default logging utility"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

SRC_URI = "\
    git://github.com/antmicro/rdfm.git;protocol=https;branch=main;destsuffix=git;subpath=tools/loggers \
"
SRCREV = "3427a59b312641d5c52914750d2a90f69bffb7c4"

FILES:${PN} = "${RDFM_LOGGERS_BINDIR}/*"

require rdfm-telemetry-default.inc
