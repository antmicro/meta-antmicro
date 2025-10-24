# This class creates a datafs partition image containing everything
# within the /data directory in the rootfs built by Yocto.
# The data partition is meant to be used for storing persistent
# data, as the rootfs is read-only by default.

# Filesystem of the datafs partition
RDFM_DATAFSIMG_TYPE ??= "ext4"
# Extension given to the datafs partition image in the deploy directory
RDFM_DATAFSIMG_EXT  ??= "flash_datafsimg"

IMAGE_CMD:datafsimg() {
	# If generating an empty image the size of the sparse block should be large
	# enough to allocate an ext4 filesystem using 4096 bytes per inode, this is
	# about 60K, so dd needs a minimum count of 60, with bs=1024 (bytes per IO)
	eval local COUNT=\"0\"
	eval local MIN_COUNT=\"60\"
	if [ $RDFM_PARTITION_SIZE_DATAFS -lt $MIN_COUNT ]; then
		eval COUNT=\"$MIN_COUNT\"
	fi

	# Create a sparse image block
	bbdebug 1 Executing "dd if=/dev/zero of=${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_DATAFSIMG_EXT} seek=${RDFM_PARTITION_SIZE_DATAFS} count=$COUNT bs=1024"
	dd if=/dev/zero of=${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_DATAFSIMG_EXT} seek=${RDFM_PARTITION_SIZE_DATAFS} count=$COUNT bs=1024

	bbdebug 1 "Actual Datafs size:  `du -s ${IMAGE_ROOTFS}/data`"
	bbdebug 1 "Actual Datafs Partition size: `stat -c '%s' ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_DATAFSIMG_EXT}`"

	# root dir argument for btrfs is under -r flag while ext filesystem uses -d flag for this purpose
	if [ ${RDFM_DATAFSIMG_TYPE} = "btrfs" ]; then
		bbdebug 1 Executing "mkfs.${RDFM_DATAFSIMG_TYPE} ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_DATAFSIMG_EXT} -r ${IMAGE_ROOTFS}/data"
		mkfs.${RDFM_DATAFSIMG_TYPE} ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_DATAFSIMG_EXT} -r ${IMAGE_ROOTFS}/data
	else
		bbdebug 1 Executing "mkfs.${RDFM_DATAFSIMG_TYPE} ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_DATAFSIMG_EXT} -d ${IMAGE_ROOTFS}/data"
		mkfs.${RDFM_DATAFSIMG_TYPE} ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_DATAFSIMG_EXT} -d ${IMAGE_ROOTFS}/data
	fi
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	fsck.${RDFM_DATAFSIMG_TYPE} -pvfD ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_DATAFSIMG_EXT} || [ $? -le 3 ]

	ln -sfn "${IMAGE_NAME}.${RDFM_DATAFSIMG_EXT}" "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${RDFM_DATAFSIMG_EXT}"
}

do_image_datafsimg[depends] += " \
	e2fsprogs-native:do_populate_sysroot \
"

# Ensure datafsimg is generated before WIC tasks that may use them
IMAGE_TYPEDEP:wic:append = " datafsimg "
