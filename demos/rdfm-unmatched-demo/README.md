# `HiFive Unmatched RDFM` demo

`rdfm-unmatched-demo` is an Over-The-Air update demo that uses [`RDFM`](https://github.com/antmicro/rdfm) for the `HiFive Unmatched` board.

You can run this demo either on real hardware, or in a simulation using [Renode](https://github.com/renode/renode).

## Building the image

You can fetch all the necessary code with:

<!-- name="fetch-sources"; transformer="echo "$TUTTEST_INPUT" | sed "/repo init/s/.*/& -b $CI_COMMIT_REF_NAME/" | sed "$ a repo forall meta-antmicro.git -c 'git checkout $CI_COMMIT_REF_NAME'"" -->
```sh
mkdir -p rdfm-unmatched-demo && cd rdfm-unmatched-demo
repo init -u https://github.com/antmicro/meta-antmicro.git -m demos/rdfm-unmatched-demo/manifest.xml
repo sync -j`nproc`
```

Next, set up the Yocto build environment with:
<!-- name="setup-yocto" -->
```sh
source sources/poky/oe-init-build-env
```

Now depending on whether you want to run the demo on real hardware or in a simulation,
you have to specify different build target for Yocto:

- Native:
<!-- name="target-native" -->
```sh
target="unmatched"
```

- Renode:
<!-- name="target-renode" -->
```sh
target="renodeunmatched"
```

Finally, to build the image, run:
<!-- name="build-image" -->
```sh
MACHINE=$target bitbake rdfm-image-minimal rdfm-image-upgraded
```

When the build process is complete, the resulting image will be stored in `build/tmp/deploy/images/$target` directory.
Looking through the contents, you will find that the build produced files necessary for booting the device,
filesystem images, `.flash.sdcard` images to write onto an s/uSD/microSD card as well as `.rdfm` packages
that can be directly used with RDFM.

## Preparing board (Native)

Produced `.flash_sdimg` image can be written to an s/uSD/microSD card and ran on board.

Unmount all mounted partitions from the card and write the image to it:
```sh
cd build/tmp/deploy/images/unmatched
sudo dd if=rdfm-image-minimal-unmatched.flash_sdimg of=/dev/sdX bs=512K iflag=fullblock oflag=direct conv=fsync status=progress
```
> :warning: Be careful while picking /dev/sdX device! Look at dmesg, lsblk, blkid, GNOME Disks, etc.
> before and after plugging in your s/uSD/microSD card to find the proper device.

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

## Preparing board (Renode)

To run the demo in Renode, you have to prepare necessary files.
You can do that by running:

<!-- name="copy-artifacts" -->
```sh
./renode/prepare-demo.sh
```

This script automatically copies necessary files from build to `renode` directory.

## Generating delta update

Run the following `rdfm-artifact` command from a directory containing the necessary files:

<!-- name="create-delta" -->
```sh
rdfm-artifact write delta-rootfs-image \
    --base-artifact rdfm-image-minimal-unmatched.rdfm \
    --target-artifact rdfm-image-upgraded-unmatched.rdfm \
    --output-path minimal-to-upgraded.rdfm
```

For more information, refer to the `meta-rdfm` [README](../../meta-rdfm/README.md#how-to-use).

## Running the demo

To allow communication between host and target devices, you first have to set up the network.
Below is an example configuration for the host:

### Configuring network

> If running the demo in Renode, create the necessary tap device first:
<!-- name="setup-tap" -->
```sh
sudo ip tuntap add dev tap50 mod tap
```

<!-- name="setup-host" -->
```sh
sudo ip addr add 192.168.230.1/24 dev tap50
sudo ip link set dev tap50 up
```

Next, start a http server from directory containing all the `.rdfm` artifacts:
<!-- name="start-server" -->
```sh
python -m http.server 12345
```

After that, boot the target device.
To start Renode simulation, run:
<!-- name="start-renode" -->
```sh
cd renode
renode linux-unmatched.resc -e start
```

Once successfully booted, log in as `root` user and finish up configuring the network on target:
<!-- name="setup-target" -->
```sh
ip link set dev eth0 down
ip addr add 192.168.230.2/24 dev eth0
ip link set dev eth0 up
```

> If you're connected to the device through UART,
> you might notice that some of your input might be interspersed
> with log output. To prevent that, you can run:
<!-- name="silence-logs" -->
```sh
dmesg -n 1
```

### Performing full rootfs update

To run a full system update, execute `rdfm install` command, providing it with the path to the full rootfs artifact:
<!-- name="update-full" -->
```sh
rdfm install http://192.168.230.1:12345/rdfm-image-upgraded-unmatched.rdfm
```
then reboot your device.
The updated system will contain `htop`, which you can verify by running
<!-- name="check-update" -->
```sh
command -v htop >/dev/null && echo "OK" || echo "Failed"
```

To commit the update, run:
<!-- name="commit-update" -->
```sh
rdfm commit
```

> :warning: To perform a reboot when running in Renode
> you have to type `machine Reset` in the Renode monitor window.

### Performing delta update

The steps needed for performing a delta update are exactly the same as when doing full rootfs update.
The only difference is in the artifact provided to `rdfm install` command:
<!-- name="update-delta" -->
```sh
rdfm install http://192.168.230.1:12345/minimal-to-upgraded.rdfm
```

> :warning: As mentioned in [meta-rdfm](../../meta-rdfm/README.md#generating-a-delta-update) description,
> to perform a delta update, you must first have performed a full rootfs update at last once.
> To do that in this demo, run the steps for [full rootfs update](#performing-full-rootfs-update),
> but replace the upgrade image with the base one:
<!-- name="update-same" -->
```sh
rdfm install http://192.168.230.1:12345/rdfm-image-minimal-unmatched.rdfm
```

