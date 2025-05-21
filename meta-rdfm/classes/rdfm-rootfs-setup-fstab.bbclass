# Append bootfs/datafs partitions to the fstab

ROOTFS_POSTPROCESS_COMMAND:append = " create_additional_parts_fstab;"

RDFM_BOOT_MOUNTPOINT ??= "/boot"

create_additional_parts_fstab () {

    if [ ! -d ${IMAGE_ROOTFS}${RDFM_BOOT_MOUNTPOINT} ]; then
        install -d ${IMAGE_ROOTFS}${RDFM_BOOT_MOUNTPOINT}
    fi

    printf "\n%s    /data    %s    defaults    0 2 \n" ${RDFM_PARTITION_DATAFS} ${RDFM_DATAFSIMG_TYPE} > ${WORKDIR}/.tmpfstab
    if [ ! -z "${RDFM_PARTITION_BOOTFS}" ]; then
        printf "\n%s    %s    %s    defaults    0 2 \n" ${RDFM_PARTITION_BOOTFS} ${RDFM_BOOT_MOUNTPOINT} "auto" >> ${WORKDIR}/.tmpfstab
    fi
    cat ${WORKDIR}/.tmpfstab >> ${IMAGE_ROOTFS}/etc/fstab
}
