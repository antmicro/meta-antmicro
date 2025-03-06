# `ZynqMP RDFM` demo

`rdfm-zynqmp-demo` is an Over-The-Air update demo that uses [`RDFM`](https://github.com/antmicro/rdfm) for the `ZynqMP ZCU102` board.

You can run this demo in a simulation using [Renode](https://github.com/renode/renode).

## Requirements

To run this demo, the following tools need to be installed:

* [RDFM Artifact utility](https://antmicro.github.io/rdfm/rdfm_artifact.html)
* [Yocto's build host requirements](https://docs.yoctoproject.org/ref-manual/system-requirements.html#required-packages-for-the-build-host)
* [`repo` tool for downloading requirements](https://gerrit.googlesource.com/git-repo#install)
* [Renode](https://github.com/renode/renode/blob/master/README.md#installation)

## Building the image

Create new `rdfm-zynqmp-demo` directory and navigate into it.
Then use `repo` tool to fetch all the necessary code.
This can be done with the following snippet:

<!-- name="fetch-sources"; transformer="echo "$TUTTEST_INPUT" | sed "/repo init/s/.*/& -b $CI_COMMIT_REF_NAME/" | sed "$ a repo forall meta-antmicro.git -c 'git checkout $CI_COMMIT_REF_NAME'"" -->
```sh
mkdir -p rdfm-zynqmp-demo && cd rdfm-zynqmp-demo
repo init -u https://github.com/antmicro/meta-antmicro.git -m demos/rdfm-zynqmp-demo/manifest.xml
repo sync -j`nproc`
```

Next, still from the `rdfm-zynqmp-demo` directory, set up the Yocto build environment with:
<!-- name="setup-yocto" -->
```sh
source sources/poky/oe-init-build-env
```

and specify the build target for Yocto:

<!-- name="target-renode" -->
```sh
target="renodezynqmp"
```

Finally, to build the image, run:
<!-- name="build-image" -->
```sh
MACHINE=$target bitbake rdfm-image-minimal rdfm-image-upgraded
```

When the build process is complete, the resulting images will be stored in `build/tmp/deploy/images/$target` directory.
Looking through the contents, you will find that the build produced files necessary for booting the device, filesystem images, `.flash.sdcard` images to write onto an s/uSD/microSD card as well as `.rdfm` packages that can be directly used with RDFM.

## Preparing board (Renode)

To run the demo in Renode, you have to prepare necessary files.
To do so, first navigate to `renode` directory, which is located back in the root demo directory, and run `prepare-demo.sh` script:

<!-- name="copy-artifacts" -->
```sh
cd ../renode && ./prepare-demo.sh
```

This script automatically copies necessary files from build to `renode` directory.

## Generating delta update

Run the following `rdfm-artifact` command from a directory containing the necessary files:

<!-- name="create-delta" -->
```sh
rdfm-artifact write delta-rootfs-image \
	--base-artifact rdfm-image-minimal-zynqmp.rdfm \
	--target-artifact rdfm-image-upgraded-zynqmp.rdfm \
	--output-path minimal-to-upgraded.rdfm
```

For more information, refer to the `meta-rdfm` [README](../../meta-rdfm/README.md#how-to-use).

## Running the demo

To allow communication between host and target devices, you first have to set up the network.
Below is an example configuration for the host:

### Configuring network

> If running the demo in Renode, create the necessary tap device on the host first:
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
renode zynqmp.resc -e start
```

Once successfully booted, log in as `root` user and finish up configuring the network on target:
<!-- name="setup-target" -->
```sh
ip link set dev eth0 down
ip addr add 192.168.230.2/24 dev eth0
ip link set dev eth0 up
```

### Performing full rootfs update

To run a full system update, execute `rdfm install` command, providing it with the path to the full rootfs artifact:
<!-- name="update-full" -->
```sh
rdfm install http://192.168.230.1:12345/rdfm-image-upgraded-zynqmp.rdfm
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

The steps needed for performing a delta update are exactly the same as when doing a full rootfs update.
The only difference is in the artifact provided to `rdfm install` command:
<!-- name="update-delta" -->
```sh
rdfm install http://192.168.230.1:12345/minimal-to-upgraded.rdfm
```

> :warning: As mentioned in [meta-rdfm](../../meta-rdfm/README.md#generating-a-delta-update) description, to perform a delta update, you must first have performed a full rootfs update at last once.
> To do that in this demo, run the steps for [full rootfs update](#performing-full-rootfs-update), but replace the upgrade image with the base one:
<!-- name="update-same" -->
```sh
rdfm install http://192.168.230.1:12345/rdfm-image-minimal-zynqmp.rdfm
```
