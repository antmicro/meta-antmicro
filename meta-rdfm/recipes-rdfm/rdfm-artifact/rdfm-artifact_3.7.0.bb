SUMMARY = "RDFM Artifact"
DESCRIPTION = "RDFM Artifact manipulation tool"
HOMEPAGE = "https://github.com/antmicro/rdfm-artifact"

SRC_URI = "git://github.com/antmicro/rdfm-artifact.git;protocol=https;branch=main;destsuffix=git/src"
SRCREV = "3281512a331abe10d2d3e82bc0b59a9bd35d855e"
LICENSE = "Apache-2.0 & BSD-2-Clause & BSD-3-Clause & ISC & MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/src/LICENSE;md5=2a944942e1496af1886903d274dedb13"

inherit go pkgconfig
# Required for fetching Go dependencies
do_compile[network] = "1"

S = "${WORKDIR}/git"
DEPENDS += "xz openssl"
GOPATHDIR = "${B}/src/"
GOPATH = "${B}:${STAGING_LIBDIR}/${TARGET_SYS}/go"
GO_IMPORT = ""

EXTRA_OEMAKE:append = " \
    -C ${GOPATHDIR} \
    GOPATH=${GOPATH} \
"

do_compile() {
    oe_runmake V=1 install
    # Workaround for https://github.com/golang/go/issues/35615 causing failures
    # when do_rm_work is executed
    find ${B}/pkg/mod -exec chmod u+w {} \;
}

do_install() {
    install -d ${D}${bindir}

    # go cross-compilation builds are in different place than native ones.
    if [ "${BUILD_ARCH}" = "${HOST_ARCH}" ]; then
        BUILD_BIN_FOLDER=${B}/bin
    else
        BUILD_BIN_FOLDER=${B}/bin/${GOOS}_${GOARCH}
    fi

    install ${BUILD_BIN_FOLDER}/rdfm-artifact -m 0755 ${D}${bindir}
}

BBCLASSEXTEND = "native nativesdk"
