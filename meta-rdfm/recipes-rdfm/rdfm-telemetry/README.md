# `rdfm-telemetry` recipe
## Introduce config files from a custom recipe
Suppose the following recipe structure:
```
.
├── files
│   └── my_new_logger.conf
├── my-new-logger.bb
└── rdfm-telemetry.bbappend
```

`rdfm-telemetry.bbappend` can then look as follows:
```
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    file://my_new_logger.conf \
"

RDEPENDS:${PN}:append = " my-new-logger"
```
