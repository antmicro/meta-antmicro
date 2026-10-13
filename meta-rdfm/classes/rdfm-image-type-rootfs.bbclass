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
	install -d "${WORKDIR}/image"
	cleandir=$(mktemp -d "${WORKDIR}/image/clean-rootfs.XXXXXX")
	if [ -z "$cleandir" ]; then
		bbfatal "Creating temporary rootfs directory failed"
	fi
	# -rlptDvz instead of -avz: no ownership preservation, so no chown(2) is attempted and mode bits are not perturbed.
	rsync -rlptDvz ${IMAGE_ROOTFS}/ $cleandir --exclude "data/*"

	# Restore root:root ownership only for root builds; fails silently for non-root builds.
	id
	chown -Rv 0:0 "$cleandir"

	# Add the owner read/search bit only where the mode denies it, so files the build user cannot read still land in the image.
	find $cleandir -type f ! -perm -0400 -exec chmod u+r {} + 2>/dev/null || true
	find $cleandir -type d ! -perm -0100 -exec chmod u+x {} + 2>/dev/null || true

	# root dir argument for btrfs is under -r flag while ext filesystem uses -d flag for this purpose
	if [ ${RDFM_ROOTFSIMG_TYPE} = "btrfs" ]; then
		bbdebug 1 Executing "mkfs.${RDFM_ROOTFSIMG_TYPE} ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT} -r $cleandir"
		mkfs.${RDFM_ROOTFSIMG_TYPE} ${@d.getVar('EXTRA_IMAGECMD:' + d.getVar('RDFM_ROOTFSIMG_TYPE')) or ''} \
			${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT} -r $cleandir
	else
		bbdebug 1 Executing "mkfs.${RDFM_ROOTFSIMG_TYPE} ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT} -d $cleandir"
		mkfs.${RDFM_ROOTFSIMG_TYPE} ${@d.getVar('EXTRA_IMAGECMD:' + d.getVar('RDFM_ROOTFSIMG_TYPE')) or ''} \
			${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT} -d $cleandir
	fi
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	fsck.${RDFM_ROOTFSIMG_TYPE} -pvfD ${IMGDEPLOYDIR}/${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT} || [ $? -le 3 ]

	ln -sfn "${IMAGE_NAME}.${RDFM_ROOTFSIMG_EXT}" "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${RDFM_ROOTFSIMG_EXT}"
}

# Redirect the rdfm-artifact packaging TMPDIR to a disk-backed dir under WORKDIR so the tar temp is not bounded by the /tmp tmpfs quota.
rdfm_artifactimg_do_package:prepend() {
	export TMPDIR="${WORKDIR}/rdfm-tmp"
	mkdir -p "$TMPDIR"
}

do_image_rootfsimg[depends] += " \
	rsync-native:do_populate_sysroot \
"
do_image_rootfsimg[depends] += " ${@bb.utils.contains('RDFM_ROOTFSIMG_TYPE', 'ext2', 'e2fsprogs-native:do_populate_sysroot', '', d)} "
do_image_rootfsimg[depends] += " ${@bb.utils.contains('RDFM_ROOTFSIMG_TYPE', 'ext3', 'e2fsprogs-native:do_populate_sysroot', '', d)} "
do_image_rootfsimg[depends] += " ${@bb.utils.contains('RDFM_ROOTFSIMG_TYPE', 'ext4', 'e2fsprogs-native:do_populate_sysroot', '', d)} "
do_image_rootfsimg[depends] += " ${@bb.utils.contains('RDFM_ROOTFSIMG_TYPE', 'btrfs', 'btrfs-tools-native:do_populate_sysroot', '', d)} "

# Ensure datafsimg is generated before WIC tasks that may use them
IMAGE_TYPEDEP:wic:append = " rootfsimg "
