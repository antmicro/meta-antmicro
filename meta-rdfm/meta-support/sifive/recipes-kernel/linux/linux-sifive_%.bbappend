FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:renodeunmatched = " \
    file://9999-renode-Enable-virtio-for-Hifive-Unmatched.patch \
"

SRC_URI:append:renodeunmatched = " file://unmatched/defconfig"
COMPATIBLE_MACHINE:append = "|(renodeunmatched)"
