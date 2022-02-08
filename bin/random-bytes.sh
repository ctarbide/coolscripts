#!/bin/sh
exec perl -le'while(read(STDIN,$d,64)){print for (unpack(q{C*},$d))}' </dev/urandom
