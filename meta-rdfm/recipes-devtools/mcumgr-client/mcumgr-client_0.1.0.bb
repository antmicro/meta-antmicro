SUMMARY = "A Rust program to run mcumgr commands, used for example for Zephyr, for uploading firmware updates from a PC to an embedded device."
HOMEPAGE = "https://github.com/vouch-opensource/mcumgr-client"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI += "git://github.com/vouch-opensource/mcumgr-client.git;protocol=https;nobranch=1"
SRCREV = "5ce495fa59c8c303f4e53872cccf1e3676765ce8"
CARGO_SRC_DIR = ""

inherit cargo cargo-update-recipe-crates pkgconfig
require ${BPN}-crates.inc

DEPENDS = " \
    dbus-native \
    dbus \
"
