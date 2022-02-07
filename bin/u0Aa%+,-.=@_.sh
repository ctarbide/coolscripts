#!/bin/sh
exec perl -l -0777 -Minteger -e'
@map=map{chr}48..57,65..90,97..122,37,43..46,61,64,95;
while(read(STDIN,$d,64)){
    for $x (unpack(q{C*},$d)) {
        next if $x >= scalar(@map);
        print($map[$x]);
}}'</dev/urandom
