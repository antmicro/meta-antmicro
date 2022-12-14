#!/bin/sh

set -ex

OLD="$1"
NEW="$2"
OUT="$3"

if [ -z "$OLD" ] || [ -z "$NEW" ]; then
    echo "Usage: $0 <old> <new> <out>"
    exit 1
fi

SIGFILE="/tmp/rootfs-$$.sig"

checksum=$(tar -xOf "$OLD" header.tar.gz |tar -xzOf- headers/0000/type-info |jq -r '.artifact_provides."rootfs-image.checksum"')
tar -xOf "$OLD" data/0000.tar.gz | tar -xzOf- | /usr/bin/rdiff signature -R rollsum -b 4096 - "$SIGFILE"

if [ -z "$OUT" ]; then
   rdfm-artifact modify --delta-compress "$SIGFILE" "$NEW"
else
   cp "$NEW" "$OUT"
   rdfm-artifact modify --delta-compress "$SIGFILE" "$OUT"
fi

rm "$SIGFILE"
