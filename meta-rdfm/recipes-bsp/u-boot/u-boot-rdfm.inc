DEPENDS:append:riscv64 = " python3"

do_mender_uboot_auto_configure:riscv64() {
    mkdir ${STAGING_INCDIR}/python3.10/python3.10
    cp ${STAGING_INCDIR}/python3.10/pyconfig* ${STAGING_INCDIR}/python3.10/python3.10/

    if [ -n "${EXTERNALSRC}" ]; then
        bbwarn "Skipping U-Boot auto-configuration when EXTERNALSRC is set. Would change the source files. If you need the patch, turn off EXTERNALSRC, call 'bitbake -c save_mender_auto_configured_patch u-boot' to generate a patch, and then apply that to your work tree and reenable EXTERNALSRC."
        exit 0
    fi

    # Try to detect whether Mender specific porting patches have already been
    # applied. To do this, we can look for "mender_setup" anywhere outside of
    # env_mender.h, since the old instructions would put it outside, and in the
    # new auto-patching it is always inside.
    if [ `fgrep -rl mender_setup ${S} | fgrep -v /env_mender.h | wc -l` -gt 0 ]; then
        bbwarn 'Detected previously applied Mender patch on top of U-Boot. Probably U-Boot will either produce compile errors or misbehave. It is advised to either remove any Mender specific patches, or disable the auto-patching by setting MENDER_UBOOT_AUTO_CONFIGURE = "0" somewhere in the U-Boot recipe.'
    fi

    cd ${WORKDIR}

    # This is for diffing and displaying the patch later, if necessary.
    rm -rf ${MENDER_UBOOT_OLD_SRC}
    cp -r "${S}" ${MENDER_UBOOT_OLD_SRC}

    # Strip leading and trailing whitespace, then newline divide.
    MENDER_UBOOT_MACHINE="$(echo "${UBOOT_MACHINE}" | sed -r 's/(^\s*)|(\s*$)//g; s/\s+/\n/g')"

    if [ -z "$MENDER_UBOOT_MACHINE" ]; then
        bbfatal "Did not find a machine specified in UBOOT_MACHINE"
        exit 1
    fi

    MACHINE_COUNT=$(echo "$MENDER_UBOOT_MACHINE" | wc -l)
    if [ "$MACHINE_COUNT" -ne 1 ]; then
        bbwarn "Found more than one machine specified in UBOOT_MACHINE. Only one should be specified. Choosing the last one."
        MENDER_UBOOT_MACHINE="$(echo "$MENDER_UBOOT_MACHINE" | tail -1)"
    fi

    env \
        BUILDCC="${BUILD_CC}" \
        CROSS_COMPILE="${TARGET_PREFIX}" \
        ./uboot_auto_configure.sh \
        --config=$MENDER_UBOOT_MACHINE \
        --src-dir=${S} \
        --tmp-dir=${MENDER_UBOOT_TMP_SRC} \
        --kconfig-fragment=${S}/mender_Kconfig_fragment \
        ${@bb.utils.contains('MENDER_FEATURES', 'mender-ubi', '--ubi', '', d)} \
        --debug

    rm ${STAGING_INCDIR}/python3.10/python3.10 -r
}
