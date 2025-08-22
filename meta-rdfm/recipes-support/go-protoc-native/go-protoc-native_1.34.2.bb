SUMMARY = "Go support for Google's protocol buffers"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

inherit go native

SRC_URI = "git://github.com/protocolbuffers/protobuf-go.git;branch=master;protocol=https;destsuffix=git"
SRCREV = "c33baa8f3a0d35fd5a39e43c22a50a050f707d34"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

do_compile () {
    GOPATH="${B}:${S}"
    export GOPATH
    PATH="${B}/bin:$PATH"
    export PATH
    cd ${S}/cmd/protoc-gen-go
    ${GO} install
}
do_compile[network] = "1"

do_install () {
    install -d ${D}${bindir}
    install -m 755 ${B}/bin/protoc-gen-go ${D}${bindir}
}
