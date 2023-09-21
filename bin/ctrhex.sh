#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
if [ -t 1 ]; then
    die 1 "Error, this is not supposed to output to a terminal."
fi

# examples:
#
#  echo -n 'my key and nonce' | ctrhex.sh | head -n10
#  echo -n 'my key and nonce' | ctrhex.sh | head -n10 | perl -lne'print(pack(q{H*},$_))'
#

exec perl -l -0777 -e'
    $_ = <>;
    $k = length($_).qq{:${_},};
    while (++$n) {
        print(unpack(q{H*},qq{${k}${n}}));
    }'
