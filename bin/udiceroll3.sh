#!/bin/sh
exec perl -l -0777 -Minteger -e'while(read(STDIN,$d,64)){
for $x (unpack(q{C*},$d)) {
    next if $x > 215;
    print($x);
}}'</dev/urandom
