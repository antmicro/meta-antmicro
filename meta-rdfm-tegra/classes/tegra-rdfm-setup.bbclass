inherit rdfm-image-setup
inherit rdfm-artifactimg

MACHINE_EXTRA_RDEPENDS:append = "\
    tegra-nvphs \
    tegra-nvs-service \
    tegra-nvsciipc \
    tegra-nvstartup \
    tegra-nvfancontrol \
    tegra-configs-udev \
    tegra-redundant-boot \
    tegra-redundant-boot-update-engine \
    watchdog-keepalive \
"

# meta-tegra and tegraflash requirements
IMAGE_CLASSES += "image_types_rdfm_tegra"
IMAGE_FSTYPES += "tegraflash"
USE_REDUNDANT_FLASH_LAYOUT = "1"

ARTIFACTIMG_FSTYPE = "ext4"
# Generate datafsimg for use with tegraflash
IMAGE_TYPEDEP:tegraflash += " datafsimg"
IMAGE_FSTYPES += "datafsimg"
