#!/usr/bin/env bash

this_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
art_dir="$this_dir/../build/tmp/deploy/images/renodezynqmp"

if [ ! -d "$art_dir" ]; then
	echo "error: Artifact directory $art_dir doesn't exist. Have you run the build instructions with 'renodezynqmp' target?"
	exit 1
fi

cp -v "$art_dir/arm-trusted-firmware.elf" "$this_dir"

cp -v "$art_dir/u-boot.bin" "$this_dir"
cp -v "$art_dir/u-boot.elf" "$this_dir"

cp -v "$art_dir/rdfm-image-minimal-renodezynqmp.rootfs-"*".rootfs.rdfm" "$this_dir/rdfm-image-minimal-zynqmp.rdfm"
cp -v "$art_dir/rdfm-image-upgraded-renodezynqmp.rootfs-"*".rootfs.rdfm" "$this_dir/rdfm-image-upgraded-zynqmp.rdfm"

cp -v "$art_dir/rdfm-image-minimal-renodezynqmp.rootfs.wic.qemu-sd" "$this_dir/sdcard.sdimg"
