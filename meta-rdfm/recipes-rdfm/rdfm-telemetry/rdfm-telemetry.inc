inherit python3native

# Returns a list of all that are `.conf` files from recipe's SRC_URI
def find_confs(d):
    sources = src_patches(d, True)
    conf_list = []
    for s in sources:
        if s.endswith('.conf'):
            conf_list.append(s)

    return conf_list

do_install() {
    install -d ${D}${sysconfdir}/rdfm
    install -m 0644 ${WORKDIR}/loggers.conf ${D}${sysconfdir}/rdfm
}

do_compile() {
    :
}

do_configure() {
    ${WORKDIR}/merge_confs.py \
        --input ${@' '.join(find_confs(d))} \
        --bindir ${RDFM_LOGGERS_BINDIR} \
        --output-conf ${WORKDIR}/loggers.conf
}
