#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
if [ -t 1 ]; then
    die 1 "Error, this is not supposed to output to a terminal."
fi
exec perl -0777 -e'
    $_ = <>;
    $k = length($_).qq{:${_},};
    sub envelope {
        return pack(q{na*}, length($_[0]), $_[0]);
    }
    while (++$n) {
        print(envelope(qq{${k}${n}}));
    }'
