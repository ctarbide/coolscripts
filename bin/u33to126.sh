#!/bin/sh
exec perl -le'
@map = map {chr} 33..126;
while (read(STDIN,$d,64)) {
    for $x (unpack(q{C*},$d)) {
        next if $x >= @map;
        print $map[$x];
    }
}' </dev/urandom
