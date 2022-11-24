def riscv_get_extra_oemake_image(d):
    sbi_payload = d.getVar('RISCV_SBI_PAYLOAD')
    deploy_dir = d.getVar('DEPLOY_DIR_IMAGE')

    if sbi_payload is None:
        return ""

    return "FW_PAYLOAD_PATH=" + deploy_dir + "/" + sbi_payload

def riscv_get_fdt_path(d):
    fdt_binary = d.getVar('RISCV_SBI_FDT')
    deploy_dir = d.getVar('DEPLOY_DIR_IMAGE')

    if fdt_binary is None:
        return ""

    return "FW_PAYLOAD_FDT_PATH=" + deploy_dir + "/" + fdt_binary

def riscv_get_do_compile_depends(d):
    sbi_payload = d.getVar('RISCV_SBI_PAYLOAD')
    fdt_binary = d.getVar('RISCV_SBI_FDT')
    depends = ""

    if 'linux' in sbi_payload or 'Image' in sbi_payload or fdt_binary:
        depends += "virtual/kernel:do_deploy "
    if 'u-boot' in sbi_payload:
        depends += "virtual/bootloader:do_deploy "

    return depends
