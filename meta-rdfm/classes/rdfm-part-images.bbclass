inherit image
inherit image_types

###############################################################################
# Image configuration
###############################################################################

IMAGE_CMD:flash_sdimg() {
    rdfm_sd_image
}

addtask do_rootfs_wicenv after do_image before do_image_flash_sdimg

_RDFM_SD_IMAGE_DEPENDS = " \
    ${@d.getVarFlag('do_image_wic', 'depends', False)} \
    coreutils-native:do_populate_sysroot \
    wic-tools:do_populate_sysroot \
    dosfstools-native:do_populate_sysroot \
    mtools-native:do_populate_sysroot \
    ${@' '.join([x + ':do_populate_sysroot' for x in d.getVar('WKS_FILE_DEPENDS').split()])} \
"
_RDFM_SD_IMAGE_DEPENDS:append:mender-uboot = " u-boot:do_deploy"
_RDFM_SD_IMAGE_DEPENDS:append:mender-systemd-boot = " \
    systemd-boot:do_deploy \
    ${IMAGE_BASENAME}:do_uefiapp_deploy \
"
do_image_flash_sdimg[depends] += "${_RDFM_SD_IMAGE_DEPENDS}"
do_image_bootimg[depends] += " virtual/kernel:do_deploy"

do_image_flash_sdimg[respect_exclude_path] = "0"

###############################################################################
# Image command
###############################################################################
rdfm_sd_image() {
    set -ex

    suffix="flash.sdimg"
    alignment_kb=$(expr ${MENDER_PARTITION_ALIGNMENT} / 1024)

    mkdir -p "${WORKDIR}"
    if ${@bb.utils.contains('MENDER_FEATURES', 'mender-uboot', 'true', 'false', d)}; then
        install -m 0644 "${DEPLOY_DIR_IMAGE}/u-boot-spl.bin" "${WORKDIR}/"
        install -m 0644 "${DEPLOY_DIR_IMAGE}/u-boot.itb" "${WORKDIR}/"
    fi

    ondisk_dev="$(basename "${MENDER_STORAGE_DEVICE}")"

    wks="${WORKDIR}/rdfm-$suffix.wks"
    rm -f "$wks"

# U-boot spl
    cat >> "$wks" <<EOF
part --source rawcopy --sourceparams="file=u-boot-spl.bin" --ondisk $ondisk_dev --fixed-size 1M --align 17 --part-type 5b193300-fc78-40cd-8002-e86c45580b47
part --source rawcopy --sourceparams="file=u-boot.itb" --ondisk $ondisk_dev --fixed-size 4M --align 1 --part-type 2e54b353-1271-4842-806f-e436d6af6985
EOF

# U-boot environment
    cat >> "$wks" <<EOF
part --ondisk $ondisk_dev --fixed-size 512K --align $alignment_kb
part --ondisk $ondisk_dev --fixed-size 512K --align $alignment_kb
EOF

# U-boot bootimg
    cat >> "$wks" <<EOF
part --source bootimg-partition --sourceparams="loader=u-boot" --ondisk $ondisk_dev --align $alignment_kb --fstype=vfat --active --size=${MENDER_BOOT_PART_SIZE_MB}M
EOF

# Rootfs partitions
    cat >> "$wks" <<EOF
part / --source rawcopy --sourceparams="file=${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${ARTIFACTIMG_FSTYPE}" --ondisk "$ondisk_dev" --align  4096 --fstype=${ARTIFACTIMG_FSTYPE} --size 5G
part --source rawcopy --sourceparams="file=${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${ARTIFACTIMG_FSTYPE}" --ondisk "$ondisk_dev" --align  4096 --fstype=${ARTIFACTIMG_FSTYPE} --size 5G
EOF

# Data partition
    cat >> "$wks" <<EOF
part --source rawcopy --sourceparams="file=${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.dataimg" --ondisk "$ondisk_dev" --align $alignment_kb --fstype=ext4 --fixed-size=128M --part-type 8300
EOF

# Bootloader
cat >> "$wks" <<EOF

bootloader --ptable gpt
EOF
    
    # Call WIC
    outimgname="${IMGDEPLOYDIR}/${IMAGE_NAME}.$suffix"
    wicout="${IMGDEPLOYDIR}/${IMAGE_NAME}-$suffix"
    BUILDDIR="${TOPDIR}" wic create "$wks" --vars "${STAGING_DIR}/${MACHINE}/imgdata/" -e "${IMAGE_BASENAME}" -o "$wicout/" ${WIC_CREATE_EXTRA_ARGS}
    mv "$wicout/$(basename "${wks%.wks}")"*.direct "$outimgname"

    rm -rf "$wicout/"
    if [ -e ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.$suffix ]; then
        rm ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.$suffix
    fi
    ln -s -r ${IMGDEPLOYDIR}/${IMAGE_NAME}.$suffix ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.$suffix
}
