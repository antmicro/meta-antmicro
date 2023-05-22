# `Jetson Orin Baseboard` BSP demo

The `nvidia-jetson-orin-baseboard-demo` release is to build BSP demo to run [the open hardware Jetson Orin Baseboard](https://github.com/antmicro/jetson-orin-baseboard).

## How to use

You can fetch all the necessary code with:
```
mkdir orin-baseboard-demo && cd orin-baseboard-demo
repo init -u https://github.com/antmicro/meta-antmicro.git -m system-releases/nvidia-jetson-orin-baseboard-demo/manifest.xml
repo sync -j`nproc`
```

To start building the BSP, run the following commands:
```
source sources/poky/oe-init-build-env
PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="p3768-0000-p3767-0000" bitbake nvidia-jetson-orin-baseboard-demo
```

When the build process is complete, the resulting image will be stored in `build/tmp/deploy/images/p3768-0000-p3767-0000` directory.

Board flashing process requires [PyYAML](https://pypi.org/project/PyYAML/) package to be pre-installed.
It can be done using:
```
sudo pip install PyYAML
```
We can unpack the tegraflash package, and then flash the board by putting the hardware in recovery mode, run the following commands:
```
cd tmp/deploy/images/p3768-0000-p3767-0000
mkdir flash-directory && cd flash-directory
tar xzvf ../nvidia-jetson-orin-baseboard-demo-p3768-0000-p3767-0000.tegraflash.tar.gz
sudo ./doflash
```

After a successful flashing, the board should boot up and a darknet visualization demo should start automatically.
