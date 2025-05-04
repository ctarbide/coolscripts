#!/usr/bin/env perl

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use strict;
use warnings FATAL => 'uninitialized';
use Carp ();
$SIG{__DIE__} = \&Carp::confess;

local $\ = "\n";

{
    local $^I;

    if ($ARGV[0] eq '-ok') {
        shift(@ARGV);
        $^I = '~';
    }

    while(<>){
        chomp;
        s,\015+$,,; # 015 is CR
        print;
    }
}
