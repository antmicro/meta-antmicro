SUMMARY = "Installs just one Micro-ROS-Agent initialization script to /etc/init.d and links to/etc/rc5.d/"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS:${PN} = "\
    bash \
"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI = "\
    file://startagent.sh \
"
S = "${WORKDIR}"

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -d ${D}${sysconfdir}/rc5.d

    install -m 0755 ${WORKDIR}/startagent.sh ${D}${sysconfdir}/init.d/
    ln -sf ../init.d/startagent.sh  ${D}${sysconfdir}/rc5.d/S97startagent.sh
}

FILES_${PN} = "\
    ${sysconfdir} \
"

