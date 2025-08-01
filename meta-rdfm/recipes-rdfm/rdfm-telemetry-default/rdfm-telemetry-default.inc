inherit go

do_compile() {
    GOPATH="${B}:${S}"
    export GOPATH
    PATH="${B}/bin:$PATH"
    export PATH

    cd ${S}
    oe_runmake V=1

    # Workaround for https://github.com/golang/go/issues/35615 causing failures
    # when do_rm_work is executed
    find ${B}/pkg/mod -exec chmod u+w {} \;
}

do_install() {
    install -d ${D}${RDFM_LOGGERS_BINDIR}
    install -m 700 ${S}/loggers ${D}${RDFM_LOGGERS_BINDIR}/loggers
    ln -sfn ${RDFM_LOGGERS_BINDIR}/loggers ${D}${RDFM_LOGGERS_BINDIR}/CPU
    ln -sfn ${RDFM_LOGGERS_BINDIR}/loggers ${D}${RDFM_LOGGERS_BINDIR}/MEM
    ln -sfn ${RDFM_LOGGERS_BINDIR}/loggers ${D}${RDFM_LOGGERS_BINDIR}/FS
}
do_install[vardeps] += "RDFM_LOGGERS_BINDIR"
