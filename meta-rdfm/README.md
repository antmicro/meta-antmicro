# `meta-rdfm` Yocto layer

Copyright (c) 2021-2023 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-rdfm` Yocto layer provides a set of recipes for tools to perform `Over The Air (OTA)` system updates.

Device support can be extended by the [meta-rdfm-tegra](../meta-rdfm-tegra) sublayer. Consider including it in your `bblayers.conf` if you are working with the Jetson family of devices.

## Layer dependencies

The `meta-rdfm` layer depends on the `meta-mender-core` sublayer presented in the [meta-mender](https://github.com/mendersoftware/meta-mender) Yocto layer.

We recommend using the `4664d5b7ebaa12dc3ba844843de8dd3d54a0585f` revision of `meta-mender-core` to ensure compatibility between meta-layers.

## local.conf configuration

In order to use `meta-rdfm` with your project, inherit from the `rdfm-full` class in your `local.conf`:

```
INHERIT += "rdfm-full"
```

**Note:** By default the `meta-rdfm` layer sets `ext4` rootfs to be read-only, as it's a requirement for reliable delta updates.
You can disable it by removing this line from `conf/layer.conf`:
```
EXTRA_IMAGECMD:ext4:append = "${@bb.utils.contains('IMAGE_FEATURES', 'read-only-rootfs', ' -O ^64bit -O ^has_journal', '', d)}"
```

For additional configuration features see [Glossary](#glossary)

## How to use

You must first build two images using `meta-rdfm` layer features in the way described in the [meta-antmicro sample use case](../README.md#meta-antmicro-sample-use-case) section, one for the initial flashing and one for the OTA update.

Once the board has been flashed with the first image, you can install the initial update.

### Generating a full-rootfs update

`meta-rdfm` will automatically generate a full-rootfs artifact for you when building a system image. This artifact can be used to update an existing RDFM-compatible device.

### Installing an update

Make sure that you have a working Ethernet connection with the target device.

On your host device, go to the directory containing built images and run server:
```
cd <folder-containing-rdfm-image>
python -m http.server 12345
```

Open the running `http.server` and copy the link to the built `.rdfm` image that will be used for an update.

On target device establish an Ethernet connection with the host device and run update installation using `rdfm-client`:
```
rdfm install <link-to-rdfm-image>
```

**Alternatively**, offline on-device updates are also possible - simply run `rdfm install` while passing a filesystem path to the update artifact, for example:
```
rdfm install <path-to-artifact.rdfm>
```

Reboot the target device and verify if partition was properly installed:
```
df -h
```

Finally, commit the update by running:
```
rdfm commit
```
**This is important**, as it marks the installed system as active. If an update is not committed after reboot, the previously installed version will be rolled back after a subsequent reboot.

You can list information about the installed artifact by using one of the following commands:
- `rdfm show-artifact` - shows the name of the installed artifact
- `rdfm show-provides` - shows the attributes of the currently installed artifact

### Generating a delta update

The `meta-rdfm` layer supports OTA updates using deltas. In order to generate one you need two already built `.rdfm` artifacts that you want to perform an update with:
- Base artifact - a full-rootfs artifact containing the currently installed system version
- Target artifact - a full-rootfs artifact containing the updated system version

To generate a delta artifact, you must install the `rdfm-artifact` tool on the host device. This can be done as follows:
```
git clone git@github.com:antmicro/rdfm-artifact.git
cd rdfm-artifact
make
make install
```
If you encounter any build errors, ensure that all of the build requirements are installed on your system - see section `Requirements` in the `rdfm-artifact` repository.

Finally, to generate a delta artifact, run the following command:
```
rdfm-artifact write delta-rootfs-image \
    --base-artifact "base.rdfm" \
    --target-artifact "target.rdfm" \
    --output-path "base-to-target.rdfm"
```

The freshly generated image with the delta update will be located in the specified output file and can be installed the same way it was described in the [Installing an update section](#installing-an-update).

**Important note:** before a delta update can be installed on the device, a full rootfs update must have been previously installed at least once. A freshly flashed system will not be able to install delta updates. To fix this, simply install a new update artifact at least once, or just install an artifact of the same system version that is currently running.

## Glossary

The meta-rdfm layer introduces new variables that affect the build process.

### RDFM_ARTIFACT_NAME

Specifies the name of the generated artifact. Required for the `rdfm` image building process.
```
RDFM_ARTIFACT_NAME = "release-1"
```

### RDFM_ARTIFACT_NAME_DEPENDS

Specifies names of artifacts that the update can be installed on top of. Attempting to install the update on a system running a different version will fail.

Defaults to an empty string, i.e no dependency.

```
RDFM_ARTIFACT_NAME_DEPENDS = "v0 v1 v2"
```

### RDFM_ARTIFACT_PROVIDES / RDFM_ARTIFACT_DEPENDS

These can be used for customized update compatibility checks beyond just the name of the artifact. 
A provide and depend value is an arbitrary key-value pair in the format `KEY:VALUE`.
This works similarly to what was described above - the currently running firmware must contain the specified dependency values for the installation to succeed.

```
RDFM_ARTIFACT_PROVIDES="hwrev:A0 featureA:test featureB:test2"
```

An update could then depend on certain device properties for successful installation:

```
RDFM_ARTIFACT_DEPENDS="hwrev:A0"
```
