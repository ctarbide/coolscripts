#!/bin/sh
# example: nofake-htmlify-chunk.sh 'process arguments' nofake.nw
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
[ "${#}" -ge 1 ] || die 1 "usage: nofake-htmlify-chunk.sh 'chunk name' file.nw"
chunk=$1; shift
nofake-split.pl "$@" | perl -le'$chunk = $ARGV[0]; while(<STDIN>){ chomp;
    do { $_=$1; s,<,&lt;,g; s,>,&gt;,g; print ; next } if m{^${id}_2: (.*)};
    undef $id;
    next unless m{^([0-9a-f]*)_1: <<(.*)>>=\s*$};
    $id=$1 if $2 eq $chunk
}' -- "${chunk}"
