#!/bin/sh
exec perl -Minteger -le'while(read(STDIN,$d,64)){
for $x (unpack(q{C*},$d)) {
    next if $x > 215;
    print($_ % 6) for ($x, $x / 6, $x / 36);
}}'</dev/urandom
