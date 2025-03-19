# `meta-antmicro-demo-base` Yocto layer

Copyright (c) 2021-2022 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-antmicro-demo-base` Yocto layer contains recipes and system settings that are target-independent and used in our demonstration systems introduced in the [demos directory](../demos).

This layer defines two users (`username:password`) in `conf/layer.conf`:
* `root:root` - The superuser account used for administrative purposes.
* `antmicro:antmicro` - User that has access to `input`, `video`, `sudo` and `dialout` groups.

## Layer dependencies

The `meta-antmicro-demo-base` layer depends on the following Yocto layers:
* `poky/meta`
* `meta-openembedded/meta-oe`
* `meta-openembedded/meta-xfce`
* [`meta-antmicro-common`](../meta-antmicro-common)
