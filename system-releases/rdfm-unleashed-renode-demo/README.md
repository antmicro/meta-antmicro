# `HiFive Unleashed Renode RDFM` demo

The `rdfm-unleashed-renode-demo` release is an Over The Air update demo using `RDFM` and performed on [Renode](https://github.com/renode/renode/) simulated `HiFive Unleashed` board.

## How to use

### Building image
You can fetch all the necessary code with:
```
mkdir rdfm-unleashed-renode-demo && cd rdfm-unleashed-renode-demo
repo init -u https://github.com/antmicro/meta-antmicro.git -m system-releases/rdfm-unleashed-renode-demo/manifest.xml -b dunfell
repo sync -j`nproc`
```

To start building the BSP, run the following commands:
```
source setup-environment
PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="freedom-u540" bitbake rdfm-image-minimal rdfm-image-upgraded
```

### Generating a delta update

Install dependencies:
```
sudo apt install rdiff
sudo apt install jq
```

When the build process is complete, the resulting image will be stored in the `build/tmp/deploy/images/freedom-u540` directory.

Clone `rdfm-artifact` on the host device and build it:
```
cd build/tmp/deploy/images/freedom-u540
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

### Running a Renode demo

After successful delta update generating, go to the `sources/meta-antmicro/system-releases/rdfm-unleashed-renode-demo/renode-demo` folder containing scripts needed for demo running.
```
cd ../../../../../sources/meta-antmicro/system-releases/rdfm-unleashed-renode-demo/renode-demo
```

Build the `docker` image containing [Renode](https://github.com/renode/renode/) and run the demo with:
```
./Dockerfile.renode
./repack.sh
./rdfm-renode.sh
```

> **Warning:** The emulated machine modifies the `volume/rdfm-image-minimal-freedom-u540.flash.sdimg` file in order to save state.
> If you want to checkpoint your work, back up that file.
> Doing `./repack.sh` overwrites the file as well, in order to always do a fresh 'first-run' start.

The `rdfm-renode.sh` script will set up the python server used for updates by itself.
On the beginning of the execution log will be displayed ip address needed for update performing:
```
+ ...
+ ADDR=<ip addr>
+ ...
```

Once the board booted, log to the `root` user and add ip address on `eth0` device for simulated connection with server. Perform the delta update using `rdfm-client` and earlier copied `<ip addr>`:
```
ip addr add <your ip addr> dev eth0
rdfm install http://<ip addr>:12345/rdfm-image-upgraded-freedom-u540.rdfm
```

Reboot the system and verify if the update was installed successfully.
The updated system will contain `htop` and `nano` packages installed and can be permanently applied using `rdfm commit`.
