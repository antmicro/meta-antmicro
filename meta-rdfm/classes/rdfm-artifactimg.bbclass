inherit rdfm-helpers

# ------------------------------ CONFIGURATION ---------------------------------

# Extra arguments that should be passed to rdfm-artifact.
RDFM_ARTIFACT_EXTRA_ARGS ?= ""

# --------------------------- END OF CONFIGURATION -----------------------------

do_image_rdfm[depends] += "rdfm-artifact-native:do_populate_sysroot"

ARTIFACTIMG_FSTYPE ??= "${ARTIFACTIMG_FSTYPE_DEFAULT}"
ARTIFACTIMG_FSTYPE_DEFAULT = "ext4"

ARTIFACTIMG_NAME ??= "${ARTIFACTIMG_NAME_DEFAULT}"
ARTIFACTIMG_NAME_DEFAULT = "${IMAGE_LINK_NAME}"

RDFM_ARTIFACT_NAME_DEPENDS ?= ""

RDFM_ARTIFACT_PROVIDES ?= ""
RDFM_ARTIFACT_PROVIDES_GROUP ?= ""

RDFM_ARTIFACT_DEPENDS ?= ""
RDFM_ARTIFACT_DEPENDS_GROUPS ?= ""

RDFM_ARTIFACT_PATH = "${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}"

apply_arguments () {
    #
    # $1 -- the command line flag to apply to each element
    # $@ -- the list of arguments to give each its own flag
    #
    local res=""
    flag=$1
    shift
    for arg in $@; do
        res="$res $flag $arg"
    done
    cmd=$res
}

IMAGE_CMD:rdfm() {
    set -x

    if [ -z "${RDFM_ARTIFACT_NAME}" ]; then
        bbfatal "Need to define RDFM_ARTIFACT_NAME variable."
    fi

    rootfs_size=$(stat -Lc %s ${IMGDEPLOYDIR}/${ARTIFACTIMG_NAME}.${ARTIFACTIMG_FSTYPE})
    calc_rootfs_size=$(expr ${MENDER_CALC_ROOTFS_SIZE} \* 1024)
    if [ $rootfs_size -gt $calc_rootfs_size ]; then
        bbfatal "Size of rootfs is greater than the calculated partition space ($rootfs_size > $calc_rootfs_size). This image won't fit on a device with the current storage configuration. Try reducing IMAGE_OVERHEAD_FACTOR if it is higher than 1.0, or raise MENDER_STORAGE_TOTAL_SIZE_MB if the device in fact has more storage."
    fi

    if [ -z "${RDFM_DEVICE_TYPES_COMPATIBLE}" ]; then
        bbfatal "RDFM_DEVICE_TYPES_COMPATIBLE variable cannot be empty."
    fi

    extra_args=

    for dev in ${RDFM_DEVICE_TYPES_COMPATIBLE}; do
        extra_args="$extra_args --device-type $dev"
    done

    if [ -n "${RDFM_ARTIFACT_NAME_DEPENDS}" ]; then
        cmd=""
        apply_arguments "--artifact-name-depends" "${RDFM_ARTIFACT_NAME_DEPENDS}"
        extra_args="$extra_args  $cmd"
    fi

    if [ -n "${RDFM_ARTIFACT_PROVIDES}" ]; then
        cmd=""
        apply_arguments "--provides" "${RDFM_ARTIFACT_PROVIDES}"
        extra_args="$extra_args  $cmd"
    fi

    if [ -n "${RDFM_ARTIFACT_PROVIDES_GROUP}" ]; then
        cmd=""
        apply_arguments "--provides-group" "${RDFM_ARTIFACT_PROVIDES_GROUP}"
        extra_args="$extra_args $cmd"
    fi

    if [ -n "${RDFM_ARTIFACT_DEPENDS}" ]; then
        cmd=""
        apply_arguments "--depends" "${RDFM_ARTIFACT_DEPENDS}"
        extra_args="$extra_args $cmd"
    fi

    if [ -n "${RDFM_ARTIFACT_DEPENDS_GROUPS}" ]; then
        cmd=""
        apply_arguments "--depends-groups" "${RDFM_ARTIFACT_DEPENDS_GROUPS}"
        extra_args="$extra_args $cmd"
    fi


    rdfm-artifact write rootfs-image \
        --artifact-name ${RDFM_ARTIFACT_NAME} \
        $extra_args \
        --file ${IMGDEPLOYDIR}/${ARTIFACTIMG_NAME}.${ARTIFACTIMG_FSTYPE} \
        ${MENDER_ARTIFACT_EXTRA_ARGS} \
        --output-path ${RDFM_ARTIFACT_PATH}.rdfm
}

IMAGE_CMD:rdfm[vardepsexclude] += "IMAGE_ID"
# We need to have the filesystem image generated already.
IMAGE_TYPEDEP:rdfm:append = " ${ARTIFACTIMG_FSTYPE}"
