require opensbi-payloads.inc

RISCV_SBI_PAYLOAD:freedom-u540 = "u-boot-dtb.bin"

EXTRA_OEMAKE:append = " ${@riscv_get_extra_oemake_image(d)}"
EXTRA_OEMAKE:append = " ${@riscv_get_fdt_path(d)}"

do_compile[depends] += "${@riscv_get_do_compile_depends(d)}"
