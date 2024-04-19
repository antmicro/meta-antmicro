# `HiFive Unmatched RDFM` demo

The `rdfm-unmatched-demo` release is an Over-The-Air update demo that uses [`RDFM`](https://github.com/antmicro/rdfm) for the `HiFive Unmatched` board.

To try out this system release without access to the hardware, refer to the [Renode demo README](./renode/README.md), which runs the demo in simulation.

## How to use

### Building the image
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

### Writing the image
When the build process is complete, the resulting image will be stored in the `build/tmp/deploy/images/unmatched` directory.
The built `.flash.sdimg` image can be written to a uSD card and ran on board.
> :warning: Be careful while picking /dev/sdX device! Look at dmesg, lsblk, blkid, GNOME Disks, etc.
> before and after plugging in your uSD card to find a proper device.

Unmount all mounted partitions from the uSD card and write the image:
```
cd tmp/deploy/images/unmatched
sudo dd if=rdfm-image-minimal-unmatched.flash.sdimg of=/dev/sdX bs=512K iflag=fullblock oflag=direct conv=fsync status=progress
```

Once written, set the HiFive Unmatched `MSEL` to a state allowing boot using U-Boot SPL, OpenSBI, U-Boot:
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
Once successfully booted, establish an Ethernet connection between the host and the target device.

On your host device, start the server in the folder containing the built images:
```
python -m http.server 12345
```

Open the running `http.server` and copy the link to the `rdfm-image-upgraded.rdfm` image that will be used for an update.

On the target device, log in as the `root` user and start the update installation using `rdfm-client` and the copied link to the update image, with the host address replaced with the IP address of the host interface used to connect to the device:
```
rdfm install <link-to-rdfm-update-image>
```

Reboot the system and verify if the update was installed successfully.
The updated system will contain `htop` and `nano` packages installed and can be permanently applied using:
```
rdfm commit
```
