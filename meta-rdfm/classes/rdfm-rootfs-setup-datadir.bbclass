# Add a /data directory to the rootfs
# This is used to store persistent data, as the rootfs is set to read-only
# when using meta-rdfm.

ROOTFS_POSTPROCESS_COMMAND:append = " rdfm_add_data_dir;"

rdfm_add_data_dir() {
    mkdir -p ${IMAGE_ROOTFS}/data
}
