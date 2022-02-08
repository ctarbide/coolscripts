#!/bin/sh
exec perl -le'
@map=map{chr}48..57,65..90,97..122;
while(read(STDIN,$d,64)){
    for $x (unpack(q{C*},$d)) {
        next if $x >= scalar(@map);
        print($map[$x]);
    }
}'</dev/urandom
