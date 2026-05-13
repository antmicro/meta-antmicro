do_install[depends] = "xmlstarlet-native:do_populate_sysroot"
PATH =. "${STAGING_BINDIR_NATIVE}/tegra-flash:"

adapt_uda_partition_for_datafsimg() {
    local file=$1
    mv ${D}${datadir}/l4t-storage-layout/$file ${WORKDIR}/$file

    # tegra-storage-layout-base inherits from tegra-shared-binaries which
    # disables the fetcher, so we can't easily add files to the workdir.
    cat >move-uda-before-secondary-gpt.xml <<EOF
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()[not(@name='UDA')]"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/partition_layout/device[not(@type='spi')]/partition[@name='secondary_gpt']">
        <xsl:copy-of select="../partition[@name='UDA']"/>
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>
EOF

    # The following transformations are applied on the L4T partition layout:
    # 1) Set data partition to auto-fill the remaining disk space (by setting
    #    allocation flags to 0x808).
    # 2) Set the data partition size based on DATASIZE.
    # 3) Set the data partition file to point to meta-rdfm generated.
    #    flash_datafsimg. The data partition will be flashed alongside the
    #    rootfs this way.
    # 4) Assign an explicit ID attribute to the data partition (15).
    # 5) Remove reserved partition which is unused with RDFM enabled.
    # 6) Move the data partition node to be right before the secondary GPT node
    #    in the partition layout, this is required by L4T for partitions that
    #    enable the autofill allocation flag.
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
    | xml edit \
        --subnode "/partition_layout/device/partition[@name='UDA']" \
        --type attr \
        -n "id" \
        -v "15" \
    | xml edit \
        --delete "/partition_layout/device/partition[@name='reserved']" \
    | xml transform move-uda-before-secondary-gpt.xml \
    > ${D}${datadir}/l4t-storage-layout/$file
}

do_install:append() {
    adapt_uda_partition_for_datafsimg "${PARTITION_LAYOUT_TEMPLATE}"
    adapt_uda_partition_for_datafsimg "${PARTITION_LAYOUT_EXTERNAL}"
}
