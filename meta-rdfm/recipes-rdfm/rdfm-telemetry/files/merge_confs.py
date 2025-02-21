#!/usr/bin/env python3
import argparse
import itertools
import json
import jsonschema


from dataclasses import dataclass
from os import path


parser = argparse.ArgumentParser(
        prog='merge_confs',
        description='Merge RDFM telemetry config files, modify or add "path" property if necessary')
parser.add_argument('--input', nargs='*', required=True)
parser.add_argument('--bindir', required=True)
parser.add_argument('--output-conf', required=True)


logger_schema = {
    "type": "array",
    "items": {
        "type": "object",
        "properties": {
            "name": { "type": "string" },
            "path": { "type": "string" },
            "args": { "type": "array", "items": {"type": "string"} },
            "tick": { "type": "number", "minimum": 1 }
        },
        "required": ["name", "tick"],
        "additionalProperties": False
    }
}


@dataclass
class LoggerConf:
    path: str
    conf: list
    err: Exception


def read(conf: list[str]) -> list[LoggerConf]:
    out = []
    for c in conf:
        try:
            out.append(LoggerConf(c, [], None))
            with open(out[-1].path) as f:
                out[-1].conf = json.loads(f.read())
            continue
        except Exception as e:
            out[-1].err = e
    return out


def validate(conf: list[LoggerConf]):
    for c in conf:
        try:
            jsonschema.validate(instance=c.conf, schema=logger_schema)
        except Exception as e:
            c.err = e
            continue


def create_exception_string(conf: list[LoggerConf]) -> str:
    exception_string = ""
    for c in conf:
        if c.err is not None:
            exception_string = exception_string \
            + f"\nencountered error when processing {c.path}:\n{c.err}\n"
    return exception_string.strip()


def prepend_bindir_if_not_abs(bindir: str, conf: list[LoggerConf]):
    # If the logger configuration does not specify a path, the logger's name will be used as its path(bindir + name).
    # If a relative path is specified, it will be appended to the logger binary directory. If an absolute path is specified, leave it as is.
    # This approach prevents potential conflicts with identically named system binaries, while still allowing absolute paths to be used when necessary.
    for c in conf:
        for cc in c.conf:
            if not cc.get("path"):
                cc["path"] = path.join(bindir, cc["name"])
            elif not path.isabs(cc["path"]):
                cc["path"] = path.join(bindir, cc["path"])


def merge(conf: list[LoggerConf]) -> list:
    return list(itertools.chain(*[c.conf for c in conf]))


if __name__ == "__main__":
    args = parser.parse_args()
    if len(args.input) == 0:
        # Write out an empty config when no .conf files are provided
        with open(args.output_conf, "w") as f:
            json.dump([], f)
        exit(0)

    conf = read(args.input)
    read_exception = create_exception_string(conf)
    if read_exception:
        raise Exception(read_exception)

    validate(conf)
    validation_exception = create_exception_string(conf)
    if validation_exception:
        raise Exception(validation_exception)

    prepend_bindir_if_not_abs(args.bindir, conf)

    with open(args.output_conf, "w") as f:
        json.dump(merge(conf), f)

