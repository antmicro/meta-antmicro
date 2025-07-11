# Create an RDFM rootfs image
# This is different from the default IMAGE_CMD for generating
# the rootfs in that the /data directory is excluded from the
# image.

# Filesystem of the rootfs partitions
RDFM_ROOTFSIMG_TYPE ??= "ext4"
# Extension given to the rootfs partition image in the deploy directory
RDFM_ROOTFSIMG_EXT  ??= "flash_rootfsimg"
ARTIFACTIMG_FSTYPE:append = " rootfsimg "

IMAGE_CMD:rootfsimg() {
	# If generating an empty image the size of the sparse block should be large
	# enough to allocate an ext4 filesystem using 4096 bytes per inode, this is
	# about 60K, so dd needs a minimum count of 60, with bs=1024 (bytes per IO)
	eval local COUNT=\"0\"
	eval local MIN_COUNT=\"60\"
	if [ $RDFM_PARTITION_SIZE_ROOTFS -lt $MIN_COUNT ]; then
		eval COUNT=\"$MIN_COUNT\"
	fi

	# Create a sparse image block
	bbdebug 1 Executing "dd if=/dev/zero of=${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT} seek=${RDFM_PARTITION_SIZE_ROOTFS} count=$COUNT bs=1024"
	dd if=/dev/zero of=${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT} seek=${RDFM_PARTITION_SIZE_ROOTFS} count=$COUNT bs=1024

	bbdebug 1 "Actual Rootfs size:  `du -s ${IMAGE_ROOTFS}`"
	bbdebug 1 "Actual Rootfs Partition size: `stat -c '%s' ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT}`"

	# mkfs does not support excluding certain folders. We need
	# to copy the prepared rootfs to a writable location, then
	# remove data/ from it.
	cleandir=$(mktemp -d "${WORKDIR}/clean-rootfs.XXXXXX")
	if [ -z "$cleandir" ]; then
		bbfatal "Creating temporary rootfs directory failed"
	fi
	rsync -avz ${IMAGE_ROOTFS}/ $cleandir --exclude "data/*"

	bbdebug 1 Executing "mkfs.${RDFM_ROOTFSIMG_TYPE} ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT} -d $cleandir"
	mkfs.${RDFM_ROOTFSIMG_TYPE} ${@d.getVar('EXTRA_IMAGECMD:' + d.getVar('RDFM_ROOTFSIMG_TYPE')) or ''} \
		${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT} -d $cleandir
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	fsck.${RDFM_ROOTFSIMG_TYPE} -pvfD ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT} || [ $? -le 3 ]

	ln -sfn "${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT}" "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${RDFM_ROOTFSIMG_EXT}"
}

do_image_rootfsimg[depends] += " \
	rsync-native:do_populate_sysroot \
	e2fsprogs-native:do_populate_sysroot \
"

# Ensure datafsimg is generated before WIC tasks that may use them
IMAGE_TYPEDEP:wic:append = " rootfsimg "
