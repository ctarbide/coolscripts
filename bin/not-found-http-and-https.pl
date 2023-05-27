#!/usr/bin/env perl

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => 'uninitialized';
use Carp ();
use Data::Dumper qw{Dumper};

$SIG{__DIE__} = \&Carp::confess;

local $\ = "\n";

my %urls;

while (<>) {
    chomp;
    s,^--2[\d\-: ]+--\s+,,;
    s,\s+$,,;
    # print;
    next unless m{^\w+://};
    $urls{$2}->{$1} = 1 if m{^(https?)://(.*)}i
}

for (sort(keys(%urls))) {
    # print(Dumper([$_, $urls{$_}]));
    my $protos = $urls{$_};
    if ($protos->{http}) {
        if (!$protos->{https}) {
            print("https://${_}");
        }
    } elsif (!$protos->{http}) {
        print("http://${_}");
    }
}
