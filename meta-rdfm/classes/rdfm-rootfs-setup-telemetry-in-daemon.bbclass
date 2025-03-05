# Enable telemetry in the RDFM daemon

IMAGE_INSTALL:append = " rdfm-telemetry"
RDFM_TELEMETRY_BATCH_SIZE ?= "50"

do_rootfs[postfuncs] += "do_qa_image_loggers_present"
python do_qa_image_loggers_present() {
    import json
    import os


    image_rootfs = d.getVar('IMAGE_ROOTFS')
    sysconfdir = d.getVar('sysconfdir')
    rdfm_loggers = 'rdfm/loggers.conf'
    loggers_conf = os.path.join(sysconfdir, rdfm_loggers)

    missing = []

    # HACK: os.path.isfile() returns False on broken symlinks
    # chroot to ${IMAGE_ROOTFS} to sidestep that
    original_root = os.open('/', os.O_RDONLY)
    original_cwd = os.open('.', os.O_RDONLY)
    try:
        os.chroot(image_rootfs)
        with open(loggers_conf, "r") as f:
            loggers_conf = json.loads(f.read())

        for conf in loggers_conf:
            conf_path = conf["path"]
            if not os.path.isfile(conf_path):
                missing.append(conf)

        error_string = ""
    except Exception as e:
        error_string = f"encountered an exception: {e}"
    finally:
        os.fchdir(original_root)
        os.chroot(".")
        os.fchdir(original_cwd)
        os.close(original_root)
        os.close(original_cwd)
        if error_string:
            bb.warn(f"RDFM Telemetry QA issue: {error_string}")

    if missing:
        missing_list = "\n"+"\n".join(m["path"] for m in missing)
        error_string = f"{len(missing)} file(s) defined in logger configuration missing from rootfs: {missing_list}\nEnsure that all .conf files appended to rdfm-telemetry's SRC_URI reference existing files within the rootfs."
        bb.warn(f"RDFM Telemetry QA issue: {error_string}")
}
