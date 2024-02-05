#!/bin/sh
# example: nofake-htmlify-chunk.sh 'process arguments' nofake.nw
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
[ "${#}" -ge 1 ] || die 1 "usage: nofake-htmlify-chunk.sh 'chunk name' file.nw"
chunk=$1; shift
escape(){
    perl -lpe's,&,&amp;,g; s,<,&lt;,g; s,:,&colon;,g; s,^\@,&#x40;,' -- "$@"
}
nofake-split.pl "$@" | perl -le'$chunk = $ARGV[0]; while(<STDIN>){
    chomp;
    if ($id) {
        if (m{^${id}_2: (.*)}) {
            print $1;
            next;
        }
        undef $id;
    }
    next unless m{^([0-9a-f]*)_1: <<(.*)>>=\s*$};
    $id = $1 if $2 eq $chunk;
}' -- "${chunk}" | escape
