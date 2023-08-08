# `HiFive Unmatched RDFM` demo

The `rdfm-unmatched-demo` release is an Over The Air update demo using the `RDFM` for `HiFive Unmatched` board.

If you wish to try out this system release but don't have access to the hardware, refer to the [Renode demo README](./renode/README.md).

## How to use

### Building image
You can fetch all the necessary code with:
```
mkdir rdfm-unmatched-demo && cd rdfm-unmatched-demo
repo init -u https://github.com/antmicro/meta-antmicro.git -m system-releases/rdfm-unmatched-demo/manifest.xml -b master
repo sync -j`nproc`
```

To start building the BSP, run the following commands:
```
source sources/poky/oe-init-build-env
PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="unmatched" bitbake rdfm-image-minimal rdfm-image-upgraded
```

### Writing image
When the build process is complete, the resulting image will be stored in the `build/tmp/deploy/images/unmatched` directory.
The built `.flash.sdimg` image can be written to a uSD card and later runned on board.
> Be very careful while picking /dev/sdX device! Look at dmesg, lsblk, blkid, GNOME Disks, etc.
> before and after plugging in your uSD card to find a proper device.

Unmount all mounted partitions from uSD card and write the image:
```
cd tmp/deploy/images/unmatched
sudo dd if=rdfm-image-minimal-unmatched.flash.sdimg of=/dev/sdX bs=512K iflag=fullblock oflag=direct conv=fsync status=progress
```

After a successful image writing to a uSD, set the HiFive Unmatched `MSEL` to state allowing boot using U-Boot SPL, OpenSBI, U-Boot:
```
 +----------> CHIPIDSEL
 | +--------> MSEL3
 | | +------> MSEL2
 | | | +----> MSEL1
 | | | | +--> MSEL0
 | | | | |
+-+-+-+-+-+
| |X| |X|X| ON(1)
| | | | | |
|X| |X| | | OFF(0)
+-+-+-+-+-+
BOOT MODE SEL
```

### Generating a delta update

Run the following `rdfm-artifact` command:

```
rdfm-artifact write delta-rootfs-image \
    --base-artifact rdfm-image-minimal-unmatched.rdfm \
    --target-artifact rdfm-image-upgraded-unmatched.rdfm \
    --output-path minimal-to-upgraded.rdfm
```

For more information, refer to the `meta-rdfm` [README](../../meta-rdfm/README.md#how-to-use).

### Running a demo
After successful booting, establish Ethernet connection between host and target device.

On your host device, start the server in the folder containing built images:
```
python -m http.server 12345
```

Open the running `http.server` and copy the link to the `rdfm-image-upgraded.rdfm` image that will be used for an update.

On target device log to the `root` user and run update installation using `rdfm-client` and copied link to update image:
```
rdfm install <link-to-rdfm-update-image>
```

Reboot the system and verify if the update was installed successfully.
The updated system will contain `htop` and `nano` packages installed and can be permanently applied using:
```
rdfm commit
```
