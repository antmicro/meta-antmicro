# `HiFive Unleashed RDFM` demo

The `rdfm-unleashed-demo` release is an Over The Air update demo using the `RDFM` for `HiFive Unleashed` board.

## How to use

### Building image

You can fetch all the necessary code with:
```
mkdir rdfm-unleashed-demo && cd rdfm-unleashed-demo
repo init -u https://github.com/antmicro/meta-antmicro.git -m system-releases/rdfm-unleashed-demo/manifest.xml -b dunfell
repo sync -j`nproc`
```

To start building the BSP, run the following commands:
```
source setup-environment
PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="freedom-u540" bitbake rdfm-image-minimal rdfm-image-upgraded
```

### Writing image

When the build process is complete, the resulting image will be stored in the `build/tmp/deploy/images/freedom-u540` directory.
The built `.flash.sdimg` image can be written to a uSD card and later runned on board.
> Be very careful while picking /dev/sdX device! Look at dmesg, lsblk, blkid, GNOME Disks, etc.
> before and after plugging in your uSD card to find a proper device.

Unmount all mounted partitions from uSD card and write the image:
```
cd tmp/deploy/images/freedom-u540
sudo dd if=rdfm-image-minimal-freedom-u540.flash.sdimg of=/dev/sdX bs=512K iflag=fullblock oflag=direct conv=fsync status=progress
```

After a successful image writing to a uSD, set the HiFive Unleashed `MSEL` to state allowing boot using U-Boot SPL, OpenSBI, U-Boot:
```
      USB   LED    Mode Select                  Ethernet
 +===|___|==****==+-+-+-+-+-+-+=================|******|===+
 |                | | | | |X| |                 |      |   |
 |                | | | | | | |                 |      |   |
 |        HFXSEL->|X|X|X|X| |X|                 |______|   |
 |                +-+-+-+-+-+-+                            |
 |        RTCSEL-----/ 0 1 2 3 <--MSEL                     |
 |                                                         |
```

### Generating a delta update

Install dependencies:
```
sudo apt install rdiff
sudo apt install jq
```

Clone `rdfm-artifact` on the host device and build it:
```
git clone https://github.com/antmicro/rdfm-artifact.git rdfm-artifact-repo
cd rdfm-artifact-repo
make
cp rdfm-artifact ../ && cd ..
```

Create a `deltas.sh` script with the following content:
```
#!/bin/sh

set -ex

OLD="$1"
NEW="$2"

SIGFILE="/tmp/rootfs-$$.sig"

checksum=$(tar -xOf "$OLD" header.tar.gz |tar -xzOf- headers/0000/type-info |jq -r '.artifact_provides."rootfs-image.checksum"')
tar -xOf "$OLD" data/0000.tar.gz | tar -xzOf- | /usr/bin/rdiff signature -R rollsum -b 4096 - "$SIGFILE"
./rdfm-artifact modify --delta-compress "$SIGFILE" "$NEW"

rm "$SIGFILE"
```

Add execution rights to the script and run it:
```
chmod +x deltas.sh
./deltas.sh rdfm-image-minimal-freedom-u540.rdfm rdfm-image-upgraded-freedom-u540.rdfm
```

After script running the `rdfm-image-upgraded-freedom-u540.rdfm` will contain a delta generated update.

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
