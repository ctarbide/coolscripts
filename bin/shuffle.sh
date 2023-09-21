#!/bin/sh
set -eu
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
"${thisdir}/csprng.sh" |
    perl -e'while(read(STDIN,$d,4096)){for(unpack(q{N*},$d)){printf(qq{%08x\n},$_)}}' |
    "${thisdir}/paste.pl" - "$@" | LC_ALL=C sort | perl -lpe's,^[[:xdigit:]]+\t,,'
