SUMMARY = "Antmicro's go-xdelta library"
DESCRIPTION = "XDelta encoding/decoding tool with Go API"
HOMEPAGE = "https://github.com/antmicro/go-xdelta"

SRC_URI = "git://github.com/antmicro/go-xdelta.git;protocol=https;branch=main;destsuffix=git/src"
SRCREV = "9180b718329b756354916b18c6ca834bbc21722c"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/src/LICENSE;md5=cf96fa0d649f7c7b16616d95e7880a73"

inherit cmake

S = "${WORKDIR}/git/src"
DEPENDS += "xz cmake-native"
EXTRA_OECMAKE = "-DCGO_INTEGRATION=ON -DENCODER=ON"

# Build a native variant too, so rdfm-artifact-native can find xdelta-native
BBCLASSEXTEND = "native nativesdk"
