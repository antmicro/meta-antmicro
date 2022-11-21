#!/bin/bash

echo "${BUILDDIR}"
cp -aL "${BUILDDIR:-../../../../../build}/tmp/deploy/images/freedom-u540/"{fw_payload.elf,rdfm-image-minimal-freedom-u540.flash.sdimg,rdfm-image-minimal-freedom-u540.rdfm,rdfm-image-upgraded-freedom-u540.rdfm} volume/
