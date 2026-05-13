do_install[depends] = "xmlstarlet-native:do_populate_sysroot"
PATH =. "${STAGING_BINDIR_NATIVE}/tegra-flash:"

adapt_uda_partition_for_datafsimg() {
    local file=$1
    mv ${D}${datadir}/l4t-storage-layout/$file ${WORKDIR}/$file

    xml edit \
        --update "/partition_layout/device/partition[@name='UDA']/allocation_attribute" \
        --value " 0x808 " \
        ${WORKDIR}/$file \
    | xml edit \
        --update "/partition_layout/device/partition[@name='UDA']/size" \
        --value " ${DATASIZE} " \
    | xml edit \
        --subnode "/partition_layout/device/partition[@name='UDA']" \
        --type elem \
        -n "filename" \
        -v " DATAFILE " \
    > ${D}${datadir}/l4t-storage-layout/$file
}

do_install:append() {
    adapt_uda_partition_for_datafsimg "${PARTITION_LAYOUT_TEMPLATE}"
    adapt_uda_partition_for_datafsimg "${PARTITION_LAYOUT_EXTERNAL}"
}
