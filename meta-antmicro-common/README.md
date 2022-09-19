# `meta-antmicro-common` Yocto layer

Copyright (c) 2021-2022 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-antmicro-common` Yocto layer contains recipes and system settings that are target-independent and used in our demonstration systems introduced in the [system-releases directory](../system-releases).

This layer defines two users (`username:password`) in `conf/layer.conf`:
* `root:root` - The superuser account used for administrative purposes.
* `antmicro:antmicro` - User that has access to `input`, `video`, `sudo` and `dialout` groups.

## Layer dependencies

The `meta-antmicro-common` layer depends on the following Yocto layers:
* `poky/meta`
* `meta-openembedded/meta-oe`
* `meta-openembedded/meta-xfce`

The `meta-antmicro-common` layer adds a `lapack-native` recipe that requires support for `fortran`.
It can be provided by adding the following lines into the build's `local.conf` file:
```
FORTRAN:forcevariable = ",fortran"
RUNTIMETARGET:append:pn-gcc-runtime = " libquadmath"
HOSTTOOLS += "gfortran"
```

Alternatively, if a custom distribution is used, the above lines can be included in the `distro.conf` file.
