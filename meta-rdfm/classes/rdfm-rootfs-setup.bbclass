# Setup the rootfs for enabling RDFM support.
# This class and inherited ones should only perform changes
# related to the rootfs itself.

inherit rdfm-rootfs-setup-daemon
inherit rdfm-rootfs-setup-datadir
inherit rdfm-rootfs-setup-fstab
