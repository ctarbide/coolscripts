#!/usr/bin/env perl

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use strict;
use warnings;

local $| = 1; # 1=autoflush-on
local $\ = "\n";

my $state = 0;
my $inc = (54 << 1) | 1;

sub pcg32_random {
    use bigint;
    no warnings 'portable';
    my $oldstate = $state;
    $state = ($oldstate * 6364136223846793005 + $inc) & 0xffffffffffffffff;
    my $xorshifted = ((($oldstate >> 18) ^ $oldstate) >> 27) & 0xffffffff;
    my $rot = $oldstate >> 59;
    return ($xorshifted >> $rot) | (($xorshifted << (-$rot & 31)) & 0xffffffff);
}

pcg32_random();
$state += 42;
pcg32_random();

sub testvector {
    # reference: pcg32-demo.c
    printf("expects: 0xa15c02b7 0x7b47f409 0xba1d3330 0x83d2f293 0xbfa4784b 0xcbed606e\n");
    printf("round 1: 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x\n", map {pcg32_random()} 1..6);
    pcg32_random() for 1..614;
    printf("expects: 0xfcef7cd6 0x1b488b5a 0xd0daf7ea 0x1d9a70f7 0x241a37cf 0x9a3857b7\n");
    printf("round 5: 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x\n", map {pcg32_random()} 1..6);
}

if ($ENV{TEST}) {
    testvector();
    exit(0);
}

if ($ENV{STATE}) {
    $state = $ENV{STATE};
}
if ($ENV{INC}) {
    $inc = $ENV{INC} | 1;
}

while (1) {
    my $v = pcg32_random();
    for (1..4) {
        print($v & 0xff);
        $v >>= 8;
    }
}
