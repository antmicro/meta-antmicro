def get_rdfm_devicetree(d):
    if "RDFM_KERNEL_DEVICETREE" in d.keys():
        return d.getVar("RDFM_KERNEL_DEVICETREE")
    return d.getVar("KERNEL_DEVICETREE").strip()

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

def storage_type(storage):
    if "mmc" in storage:
        return "mmc"
    return ""

def storage_device(storage):
  if not storage.startswith("/dev/mmcblk"):
    bb.error(f"Storage {storage} does not start with /dev/mmcblk")
  import re

  result = re.findall("/dev/mmcblk(\\d+)", storage)
  if len(result) == 0:
    bb.error(f"Failed extracting storage device number from {storage}")
  return result[0]

add_config_definition() {
    CONFIG=$1
    DEFINITION=$2
    VALUE=$3
    replace=0

    grep -q $DEFINITION $CONFIG && replace=1

    if [[ $replace ]]; then
        sed -i "s@${DEFINITION}=.*@${DEFINITION}=${VALUE}@" ${CONFIG}
    else
        echo "${DEFINITION}=${VALUE}" >> ${CONFIG}
    fi
}

