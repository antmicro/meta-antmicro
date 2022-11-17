SUMMARY = "A generic recipe to place protoplater config in the rootfs."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS_${PN} += "python3-protoplaster"

TEST_DEST ?= "${ROOT_HOME}/protoplaster-conf"

FILES_${PN} = " \
    ${TEST_DEST} \
"

do_install() {
    install -d ${D}/${TEST_DEST}
    cp -r ${S}/* ${D}/${TEST_DEST}
}
