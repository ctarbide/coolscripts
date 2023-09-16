#!/usr/bin/env perl
eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;
use strict;
use warnings;
while (read(STDIN, $_, 1<<16)) {
    print(chr(ord($_) & 0xf0)) for split(//, $_);
}
