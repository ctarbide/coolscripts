#!/usr/bin/env perl

# reference: PoC||GTFO 0x01

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => 'uninitialized';
use Carp ();
$SIG{__DIE__} = \&Carp::confess;

use Time::HiRes qw(gettimeofday);

local $| = 1; # 1=autoflush-on
local $\ = "\n";

# function millis()         { return Date.now(); }
# function flip_coin()      { n=0; then = millis()+1; while(millis()<=then) { n=!n; } return n; }
# function get_fair_bit()   { while(1) { a=flip_coin(); if(a!=flip_coin()) { return(a); } } }
# function get_random_byte(){ n=0; bits=8; while(bits--){ n<<=1; n|=get_fair_bit(); } return n; }

sub micros { my ($s, $u) = gettimeofday(); return $s * 1000000 + $u; }

sub flip_coin {
    my $m = micros();
    my $n = $m & 1;
    my $then = $m + 300;
    while (micros() <= $then) { $n++ };
    return $n & 1;
}

sub get_random_byte {
    return     flip_coin() | (flip_coin() << 1) | (flip_coin() << 2) | (flip_coin() << 3) |
        (flip_coin() << 4) | (flip_coin() << 5) | (flip_coin() << 6) | (flip_coin() << 7);
}

while (1) {
    print(get_random_byte());
}
