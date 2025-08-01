# `rdfm-telemetry` recipe

## Introduce config files from a custom recipe

Suppose the following recipe structure:

```
.
├── files
│   └── my_new_logger.conf
├── my-new-logger.bb
└── rdfm-telemetry-config.bbappend
```

`rdfm-telemetry-config.bbappend` can then look as follows:

```
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    file://my_new_logger.conf \
"

RDEPENDS:${PN}:append = " my-new-logger"
```

`my-new-logger` can then install the logging utility declared in `my_new_logger.conf`.
