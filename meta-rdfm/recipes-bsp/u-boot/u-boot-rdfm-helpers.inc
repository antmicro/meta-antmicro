def get_rdfm_devicetree(d):
    if "RDFM_KERNEL_DEVICETREE" in d.keys():
        return d.getVar("RDFM_KERNEL_DEVICETREE")
    if "KERNEL_DEVICETREE" not in d.keys():
        bb.error("Missing devicetree configuration")
    devicetree = d.getVar("KERNEL_DEVICETREE").strip()
    if "/" in devicetree:
      devicetree = devicetree.split("/")[-1]
    return devicetree

def get_rdfm_kernel_type(d):
    image_type = d.getVar("KERNEL_IMAGETYPE")
    if "uImage" in image_type or "fitImage" in image_type:
        return image_type, "bootm"
    elif "zImage" in image_type:
        return image_type, "bootz"
    elif "Image" in image_type:
        return image_type, "booti"
    return image_type, "bootz"

def to_hex(value):
    return hex(int(value))

def storage_type(d):
    if "RDFM_UBOOT_STORAGE_INTERFACE" in d.keys():
        return d.getVar("RDFM_UBOOT_STORAGE_INTERFACE")
    if "RDFM_STORAGE_DEVICE" not in d.keys():
        bb.error("RDFM_STORAGE_DEVICE is not defined")
    return "mmc" if "mmc" in d.getVar("RDFM_STORAGE_DEVICE") else ""

def storage_device(d):
    if "RDFM_STORAGE_DEVICE" not in d.keys():
        bb.error("RDFM_STORAGE_DEVICE is not defined")
    storage = d.getVar("RDFM_STORAGE_DEVICE")
    if not storage.startswith("/dev/mmcblk"):
        return "0", storage
    import re

    result = re.findall("/dev/mmcblk(\\d+)", storage)
    if len(result) == 0:
        bb.error(f"Failed extracting storage device number from {storage}")
    return result[0], f"{storage}p"

add_config_definition() {
    CONFIG="$1"
    DEFINITION="$2"
    VALUE="$3"
    replace=0

    grep -q "$DEFINITION" "$CONFIG" && replace=1

    if [[ $replace ]]; then
        sed -i "s@${DEFINITION}=.*@${DEFINITION}=${VALUE}@" "${CONFIG}"
    else
        echo "${DEFINITION}=${VALUE}" >> "${CONFIG}"
    fi
}

remove_definition() {
  DIRECTORY="$1"
  DEFINITION="$2"

  grep -rl -e "#define\s*$DEFINITION" -e "#undef\s*$DEFINITION" $DIRECTORY | while read -r file; do
    sed -i -n "/#undef\s*$DEFINITION/!p" $file
    sed -i -n "/#define\s*$DEFINITION/!p" $file
  done
}

redefine() {
    DIRECTORY=$1
    CONFIG=$2
    DEFINITION=$3
    VALUE=$4

    remove_definition "$DIRECTORY" "$DEFINITION"
    add_config_definition "$CONFIG" "$DEFINITION" "$VALUE"

}
