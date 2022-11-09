FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append:mender-uboot:freedom-u540 = " \
    file://0001-Remove-unleashed-mmc.patch \
    file://0001-unleashed-renode-virtio.patch \
    file://unleashed.cfg \
"

DEPENDS:remove:freedom-u540 = "opensbi"

do_deploy:append() {
    install -D -m 644 ${B}/u-boot-dtb.bin ${DEPLOYDIR}/
}

mender_create_fw_env_config_file:freedom-u540() {
    # Takes one argument, which is the file to put it in.
    set -x

    # fw-utils is able to handle hex values.
    HEX_BOOTENV_SIZE="$(printf 0x%x "${BOOTENV_SIZE}")"

    # create fw_env.config file
    cat > $1 <<EOF
${MENDER_BOOT_PART_MOUNT_LOCATION}/uboot.env 0x0 $HEX_BOOTENV_SIZE
${MENDER_BOOT_PART_MOUNT_LOCATION}/uboot.env 0x0 $HEX_BOOTENV_SIZE
EOF
}

get_part_number_from_device() {
    dev_base="unknown"
    case "$1" in
        /dev/mmcblk*p* )
            dev_base=$(echo $1 | cut -dk -f2 | cut -dp -f2)
            ;;
        /dev/[shv]d[a-z][1-9])
            dev_base=${1##*d[a-z]}
            ;;
        /dev/nvme[0-9]n[0-9]p[0-9])
            dev_base=$(echo $1 | cut -dp -f2)
            ;;
        ubi*_* )
            dev_base=$(echo $1 | cut -d_ -f2)
            ;;
        /dev/disk/by-partuuid/* )
            bberror "Please enable mender-partuuid Distro feature to use PARTUUID"
            ;;
    esac
    part=$(printf "%d" $dev_base 2>/dev/null)
    if [ $? = 1 ]; then
        bberror "Could not determine partition number from $1"
        exit 1
    else
        echo $part
    fi
}
