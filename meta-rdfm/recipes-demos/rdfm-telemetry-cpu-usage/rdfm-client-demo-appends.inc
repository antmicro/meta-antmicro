# Pin this since the demo will probably change
SRCREV = "636fcf9ab5a695852b18c2cea2c5f7e0a807b412"

DEPENDS += "openssl-native"

RDFM_SERVER_CERTIFICATE_BSP_PATH = "${localstatedir}/lib/rdfm/CA.crt"

do_compile:append () {
    # we need PKCS#1 not PKCS#8
    openssl genrsa -traditional -out ${WORKDIR}/rsa.pem 1024
}

do_install:append () {
    install -m 600 ${WORKDIR}/rsa.pem ${D}/data/rdfm/rsa.pem
}

FILES:${PN} += "\
    /data/rdfm/rsa.pem \
"
