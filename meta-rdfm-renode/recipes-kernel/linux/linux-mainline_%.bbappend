FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:freedom-u540 = " \
  file://0004-unleashed-renode-virtio.patch \
  file://extra-virtio.cfg \
"
