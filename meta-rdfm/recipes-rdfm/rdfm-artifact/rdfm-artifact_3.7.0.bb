SUMMARY = "RDFM Artifact"
DESCRIPTION = "RDFM Artifact manipulation tool"
HOMEPAGE = "https://github.com/antmicro/rdfm"

SRC_URI = "git://github.com/antmicro/rdfm.git;protocol=https;branch=main;destsuffix=git/src"
SRCREV = "c78681233a565058521821d798bc3bddba5c9c29"
LICENSE = "Apache-2.0 & BSD-2-Clause & BSD-3-Clause & ISC & MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/src/LICENSE;md5=2a944942e1496af1886903d274dedb13"

inherit go pkgconfig
# Required for fetching Go dependencies
do_compile[network] = "1"

S = "${WORKDIR}/git"
DEPENDS += "xz openssl go-xdelta"
GOPATHDIR = "${B}/src/tools/rdfm-artifact"
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
