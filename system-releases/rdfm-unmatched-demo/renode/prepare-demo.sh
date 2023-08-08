#!/usr/bin/env bash

if [ -z "$BUILDDIR" ]; then
	echo "error: BUILDDIR variable is not set, are you in a Yocto environment?"
	exit 1
fi

cp -v "$BUILDDIR/tmp/deploy/images/renodeunmatched/u-boot-spl.bin" .
cp -v "$BUILDDIR/tmp/deploy/images/renodeunmatched/u-boot.itb" .

if [ ! -f ./sdcard.sdimg ]; then
	cp -v "$BUILDDIR/tmp/deploy/images/renodeunmatched/rdfm-image-minimal-renodeunmatched.flash.sdimg" ./sdcard.sdimg
else
	echo "SD card image already present, skipping copy"
fi

