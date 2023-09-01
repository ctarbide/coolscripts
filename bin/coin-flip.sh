#!/bin/sh
exec perl -le'while(read(STDIN,$d,64)){
    print for split(//,unpack(q{B*},$d));
}'</dev/urandom
