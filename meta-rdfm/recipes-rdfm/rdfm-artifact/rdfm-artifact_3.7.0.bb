SUMMARY = "RDFM Artifact"
DESCRIPTION = "RDFM image artifact library"
HOMEPAGE = "https://github.com/antmicro/rdfm-artifact"

SRC_URI = "git://github.com/antmicro/rdfm-artifact.git;protocol=https;branch=main;destsuffix=git/src"
SRCREV = "a38e0e60aa2c710d0d33f86157b6bac098ad2e1d"
SRCREV[sha256sum] = "06062eeeae20e13789b122ec488b6de80fa9d61f725fe7023c97c21a45863216"
SRCREV[md5sum] = "4fbbe446c9c8d5bb956aee11f052a242"
LICENSE = "Apache-2.0 & BSD-2-Clause & BSD-3-Clause & ISC & MIT"
LIC_FILES_CHKSUM = "file://src/LICENSE;md5=fbe9cd162201401ffbb442445efecfdc"

inherit go

S = "${WORKDIR}/git"
DEPENDS += "xz"
GOPATHDIR = "${B}/src/"
GOPATH = "${B}:${STAGING_LIBDIR}/${TARGET_SYS}/go"
GO_IMPORT = ""

EXTRA_OEMAKE:append = " \
    -C ${GOPATHDIR} \
    GOPATH=${GOPATH} \
"

do_compile() {
    oe_runmake V=1 install
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
