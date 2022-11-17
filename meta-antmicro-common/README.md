# `meta-antmicro-common` Yocto layer

Copyright (c) 2021-2022 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-antmicro-common` Yocto layer contains recipes for common target-independent tools.

## Layer dependencies

The `meta-antmicro-common` layer depends on the following Yocto layers:

* `poky/meta`
* `meta-openembedded/meta-oe`

The `meta-antmicro-common` layer adds a `lapack-native` recipe that requires support for `fortran`.
It can be provided by adding the following lines into the build's `local.conf` file:
```
FORTRAN:forcevariable = ",fortran"
RUNTIMETARGET:append:pn-gcc-runtime = " libquadmath"
HOSTTOOLS += "gfortran"
```

Alternatively, if a custom distribution is used, the above lines can be included in the `distro.conf` file.
