#!/bin/sh
exec perl -Minteger -le'while(read(STDIN,$d,64)){
for $x (unpack(q{C*},$d)) {
    next if $x > 215;
    print($x % 36);
}}'</dev/urandom
