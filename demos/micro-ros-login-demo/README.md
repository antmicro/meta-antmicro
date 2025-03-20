# `micro-ROS` Demo with login shell

`micro-ros-login-demo` is a root filesystem used for testing and development of micro-ROS based applications focused mainly on running in Renode. 
It installs a core ROS 2 Galactic toolchain alongside additional recipes adding micro-ROS-agent and its dependencies from recipes found in this repository.
This image automatically launches one instance of the micro-ROS agent on one of the available UART ports and spawns a bash shell on the other for testing and interacting with the system.

## How to use

You can fetch all the necessary code with:
```
mkdir micro-ros-login && cd micro-ros-login
repo init -u https://github.com/antmicro/meta-antmicro  -m demos/micro-ros-login-demo/manifest.xml
repo sync -j`nproc`
```

Before building an image you need to compile a devicetree from Antmicro's fork of the Xilinx kernel.
Alternatively, there are prebuilt binaries available for download - run the following command from the `micro-ros-login-demo` directory:
``` 
wget -O sources/zedboard.dtb https://dl.antmicro.com/projects/renode/zedboard--microros.dtb-s_11991-0b362228a3e8d1a43cf772d4cda5795311a0c9ce
```
To compile from source:
```
cd kernel_ws
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j `nproc` virtio_zynq_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j `nproc` dtbs
cp arch/arm/boot/dts/zynq-zed-virtio.dtb ../sources/zedboard.dtb
```

To start building the image, run the following commands:
```
source sources/poky/oe-init-build-env
MACHINE="zedboard-zynq7" bitbake ros-image-core
```

When the build process is complete, the resulting tarball will be stored in `build/tmp/deploy/images/**/ros-image-core-galactic-zedboard-zynq7-*rootfs.tar.gz`
To build a rootfs image:  
```
mkdir fs
cp build/tmp/deploy/images/**/ros-image-core-galactic-zedboard-zynq7-*rootfs.tar.gz ./fs
cd fs
tar -xvf ./ros-image-core-galactic-zedboard-zynq7-*rootfs.tar.gz
mv ./ros-image-core-galactic-zedboard-zynq7-*rootfs.tar.gz ../
cd ..
truncate --size=200M zynq_micro_ros_agent_rootfs.img
sudo chown -R root:root ./fs
mkfs.ext4 -d fs zynq_micro_ros_agent_rootfs.img
rm -rf fs
```
Usage and details on the demo can be found in [this repository](https://github.com/antmicro/renode-microros-demo).
