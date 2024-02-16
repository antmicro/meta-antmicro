SUMMARY = "RDFM artifact info"
HOMEPAGE = "https://antmicro.com/"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

S = "${WORKDIR}"

inherit allarch

PV = "0.1"

do_compile() {
    if [ -z "${RDFM_ARTIFACT_NAME}" ]; then
        bberror "Need to define RDFM_ARTIFACT_NAME variable."
        exit 1
    fi

    cat > ${B}/artifact_info << END
artifact_name=${RDFM_ARTIFACT_NAME}
END
    touch ${B}/provides_info
}

do_install() {
    install -d ${D}${sysconfdir}/rdfm
    install -m 0644 -t ${D}${sysconfdir}/rdfm ${B}/artifact_info
    install -m 0644 -t ${D}${sysconfdir}/rdfm ${B}/provides_info
}

FILES:${PN} += " \
    ${sysconfdir}/rdfm/artifact_info \
    ${sysconfdir}/rdfm/provides_info \
"
