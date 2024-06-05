#!/usr/bin/env bash

this_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
art_dir="$this_dir/../rdfm-unmatched-demo/build/tmp/deploy/images/renodeunmatched"

if [ ! -d "$art_dir" ]; then
	echo "error: Artifact directory $art doesn't exist. Have you run the build instructions with `renodeunmatched` target?"
	exit 1
fi

cp -v "$art_dir/u-boot-spl.bin" "$this_dir"
cp -v "$art_dir/u-boot.itb" "$this_dir"

cp -v "$art_dir/rdfm-image-minimal-renodeunmatched.rdfm" "$this_dir/rdfm-image-minimal-unmatched.rdfm"
cp -v "$art_dir/rdfm-image-upgraded-renodeunmatched.rdfm" "$this_dir/rdfm-image-upgraded-unmatched.rdfm"

if [ ! -f ./sdcard.sdimg ]; then
	cp -v "$art_dir/rdfm-image-minimal-renodeunmatched.flash.sdimg" "$this_dir/sdcard.sdimg"
else
	echo "SD card image already present, skipping copy"
fi

