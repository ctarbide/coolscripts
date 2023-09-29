#!/bin/sh
if [ x"${1}" = x0 ]; then
    exec perl -e'open(DATA,q{<},$ARGV[1]);while(read(STDIN,$a,1)){last unless read(DATA,$b,1);print(chr(ord($a) ^ ord($b)))}' -- "$@"
fi
if [ $# -eq 1 ]; then
    exec perl -e'$c=$ARGV[0]^0xff;while(read(STDIN,$_,1)){$a=ord;print(chr(($a & $c) ^ $a))}' -- "$@"
fi
exec perl -e'
    $c=$ARGV[0]^0xff;
    open(DATA,q{<},$ARGV[1]);
    while(read(STDIN,$a,1)){last unless read(DATA,$b,1);print(chr((ord($a) & $c) ^ ord($b)))}' -- "$@"
