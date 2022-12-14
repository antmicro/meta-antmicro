# `HiFive Unleashed Renode RDFM` demo

The `rdfm-unleashed-renode-demo` release is an Over The Air update demo using `RDFM` and performed on [Renode](https://github.com/renode/renode/) simulated `HiFive Unleashed` board.

## How to use

### Demo Overview

The `renode-demo` directory contains all the files needed to run the over-the-air update demo. It includes scripts and configuration files to set up the demo environment and run the demo.

#### Scripts

* `repack.sh`: Copies all built artifacts to a dedicated folder.
* `download.sh`: (located in the `resources/` directory): Downloads prebuilt artifacts used for demo.
* `clean.sh`: Removes all temporary files (such as built artifacts) from the demo folder.
* `deltas.sh`: (located in the `resources/` directory): Generates a delta update from two provided files. To use, run `deltas.sh <old-image.rdfm> <new-image.rdfm>`. The generated delta update will be placed in the `<new-image.rdfm>` file.

#### Directories

* `Docker/`: Contains the `Dockerfile.renode` script, used to build a Docker image with all the necessary dependencies for running the demo.
* `resources/`: Contains the `deltas.sh` script (as mentioned above) and other Renode-related files for machine configuration.

An overview of the file structure:
```
renode-demo
├── clean.sh
├── Docker
│   └── Dockerfile.renode
├── repack.sh
└── resources
    ├── deltas.sh
    ├── download.sh
    ├── rdfm-demo.resc
    ├── rdfm-renode.sh
    ├── sifive-fu540.repl
    ├── sifive-fu540-reset.repl
    ├── SiFive-FU540.robot
    └── resources
```

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

Clone `rdfm-artifact` on the host device and install it:
```
cd build/tmp/deploy/images/freedom-u540
git clone https://github.com/antmicro/rdfm-artifact.git rdfm-artifact-repo
cd rdfm-artifact-repo
make
install -m 755 rdfm-artifact /usr/bin
cd ..
```

When generating a delta update it's recommended to use the [deltas.sh](renode-demo/resources/deltas.sh) script presented under the `renode-demo/resources` directory:
```
./deltas.sh <initial-image.rdfm> <image-with-update.rdfm> <output.rdfm>
```

After script execution the `<output.rdfm>` will contain a delta-generated update.

### Running a Renode demo

After successful delta update generating, go to the `sources/meta-antmicro/system-releases/rdfm-unleashed-renode-demo/renode-demo` folder containing scripts needed for demo running.
```
cd ../../../../../sources/meta-antmicro/system-releases/rdfm-unleashed-renode-demo/renode-demo
```

Build the `docker` image containing [Renode](https://github.com/renode/renode/) and run the demo with:
```
cd Docker/ && ./Dockerfile.renode && cd ..
./repack.sh
docker run --rm -v $PWD/resources:/data -v /dev/net/tun:/dev/net/tun --name=reno2 --cap-add=net_admin -it renoderdfm bash
cd /data && ./rdfm-renode.sh
```

> **Warning:** The emulated machine modifies the `resources/rdfm-image-minimal-freedom-u540.flash.sdimg` file in order to save state.
> If you want to checkpoint your work, back up that file.
> Doing `./repack.sh` overwrites the file as well, in order to always do a fresh 'first-run' start.

The `rdfm-renode.sh` script will set up the python server and ip address used for updates by itself.
Once the board booted, log to the `root` user and add ip address on `eth0` device for simulated connection with server. Perform the delta update using `rdfm-client`:
```
Poky (Yocto Project Reference Distro) 3.1.21 freedom-u540 ttySIF0

freedom-u540 login: root

root@freedom-u540:~# ip addr add 100.64.0.2/10 dev eth0
root@freedom-u540:~# rdfm install http://100.64.0.1:12345/<output.rdfm>
```

Reboot the system and verify if the update was installed successfully.
The updated system will contain `htop` and `nano` packages installed and can be permanently applied using `rdfm commit`.
