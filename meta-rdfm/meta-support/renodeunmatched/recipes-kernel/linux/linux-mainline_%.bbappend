FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:renodeunmatched = " \
    file://9999-renode-Enable-virtio-for-Hifive-Unmatched.patch \
"

COMPATIBLE_MACHINE:append = "|(renodeunmatched)"
