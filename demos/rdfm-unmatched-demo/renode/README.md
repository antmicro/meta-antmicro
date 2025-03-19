# `HiFive Unmatched RDFM` Renode demo

You can run `rdfm-unmatched-demo` in simulated hardware using the [Renode](https://renode.io/) framework.

## Installing Renode

Follow the installation instructions in the Renode [documentation](https://renode.readthedocs.io/en/latest/introduction/installing.html).

## Building the demo

A compatible demo can be built in the same way as described in the `rdfm-unmatched-demo` [README](../README.md). Use the `renodeunmatched` machine type when building the system image, for example:

```
PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="renodeunmatched" bitbake rdfm-image-minimal rdfm-image-upgraded
```

You can find the built system images and pregenerated artifacts in the `build/tmp/deploy/images/renodeunmatched` directory.

## Running the demo

**Automatic**: Run the `prepare-demo.sh` script from within this (`/renode`) folder.
The script automatically copies the necessary files. 
In order to run it, you must be in a Yocto build environment.

**Manual**: From the build directory, copy the `u-boot-spl.bin` and `u-boot.itb` files to this folder.
Additionally, copy the `rdfm-image-minimal-renodeunmatched.flash_sdimg` file and rename it to `sdcard.sdimg`.
You only need to perform this step once, as you'll be updating the SD card image directly from the OS later.

To start the demo, run the following in this directory:
```
renode linux-unmatched.resc -e start
```

Depending on your system configuration you may be asked for your user password - this is required in order to create the TAP network interface for the emulated board.

`root` is the default user on the emulated machine.
There is no password.

## Configuring the network

On the emulated machine, run:

```
ip link set eth0 down
ip addr add 192.168.230.2/24 dev eth0
ip link set eth0 up
```

On the host, run:

```
sudo ip link set tap0 down
sudo ip addr add 192.168.230.1/24 dev tap0
sudo ip link set tap0 up
```

## RDFM demo

You can now continue as described in the [Running a demo](../README.md#running-a-demo) section of the rdfm-unmatched-demo README.

## Known emulation issues

### Linux Power Off / Reboot does not work correctly

To power off the machine, type `quit` in the Renode monitor window.

To restart the machine, type `machine Reset` in the Renode monitor window.

### Booting hangs at/around Avahi mDNS/DNS-SD Stack
### Sporadic kernel panics on network usage

Shutdown the machine by typing `quit` in the Renode monitor window. 
Then, remove the host's TAP interface by running:

```
sudo ip link delete tap0
```
Then, restart the emulated machine. This might take one or two retries.

This happens rarely due to a race condition within the Ethernet driver, which is out of scope of this demo.
