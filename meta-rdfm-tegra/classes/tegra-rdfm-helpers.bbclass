def rdfm_tegra_default_rootfs_size(d):
    return str(int(d.getVar('ROOTFSPART_SIZE')) // 1024)

def rdfm_tegra_default_datafs_size(d):
    return str(int(d.getVar('DATASIZE')) // 1024)
