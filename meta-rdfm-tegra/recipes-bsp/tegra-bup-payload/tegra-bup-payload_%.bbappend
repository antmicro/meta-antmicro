do_install() {
    install -d ${D}/opt/ota_package/
    if [ -e ${DEPLOY_DIR_IMAGE}/${BUPFILENAME}.bl_only.bup-payload ]; then
        install -m 0644 ${DEPLOY_DIR_IMAGE}/${BUPFILENAME}.bl_only.bup-payload ${D}/opt/ota_package/bl_only_payload
    fi
    if [ -e ${DEPLOY_DIR_IMAGE}/${BUPFILENAME}.kernel_only.bup-payload ]; then
        install -m 0644 ${DEPLOY_DIR_IMAGE}/${BUPFILENAME}.kernel_only.bup-payload ${D}/opt/ota_package/kernel_only_payload
    fi
}

RDEPENDS:${PN}:remove = "tegra-redundant-boot-update-engine"

