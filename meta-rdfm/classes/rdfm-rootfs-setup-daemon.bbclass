# Install the RDFM daemon and dependencies in the rootfs

IMAGE_INSTALL:append = " rdfm-client"

ROOTFS_POSTPROCESS_COMMAND += "write_rdfm_artifact_info; "

write_rdfm_artifact_info() {
    if [ -z "${RDFM_ARTIFACT_NAME}" ]; then
        bbfatal "Need to define variable RDFM_ARTIFACT_NAME"
    fi
    if [ -z "${RDFM_PROVIDES_INFO_LINK}" ]; then
        bbfatal "Need to define variable RDFM_PROVIDES_INFO_LINK"
    fi

    install -d ${IMAGE_ROOTFS}${sysconfdir}/rdfm
    printf 'artifact_name=%s\n' "${RDFM_ARTIFACT_NAME}" \
        > ${IMAGE_ROOTFS}${sysconfdir}/rdfm/artifact_info
    chmod 0644 ${IMAGE_ROOTFS}${sysconfdir}/rdfm/artifact_info

    ln -s ${RDFM_PROVIDES_INFO_LINK} ${IMAGE_ROOTFS}${sysconfdir}/rdfm/provides_info
}
