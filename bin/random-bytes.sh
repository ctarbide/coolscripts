#!/bin/sh
exec perl -l -0777 -e'while(read(STDIN,$d,64)){print for (unpack(q{C*},$d))}' </dev/urandom
