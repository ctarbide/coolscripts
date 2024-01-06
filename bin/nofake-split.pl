#!/usr/bin/env perl

# stripped down version of nofake.pl that only parses noweb files

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => qw{uninitialized void inplace};
use Carp ();
$SIG{__DIE__} = \&Carp::confess;

local $\ = "\n";

my $carp_or_croak = \&Carp::carp;

my $chunk_id = 0;
my $chunk = sprintf("%08x", $chunk_id++);

my $inside_chunk = 0;

sub read_file {
    local @ARGV = @_;
    while (my $line = <>) {
        chomp($line);
        if ($line =~ m{^<<(.+?)>>=\s*$}) {
            $inside_chunk = 1;
            $chunk = sprintf("%08x", $chunk_id++);
            print("${chunk}_1: " . $line);
        } elsif ($inside_chunk) {
            if ($line =~ m{^\@(?:$|\s)}) {
                $inside_chunk = 0;
                print("${chunk}_3: " . $line);
                $chunk = sprintf("%08x", $chunk_id++);
            } else {
                # regular line inside chunk
                $line =~ s,^\@\@,\@,;
		print("${chunk}_2: " . $line);
            }
        } else {
            if ($line =~ m{^(|.*?[^\@])<<} and $1 !~ m{\[\[}) {
                $carp_or_croak->("WARNING: Unescaped << in documentation" .
                    " chunk at line ${ARGV}:${.}.");
            }
            print("${chunk}_0: " . $line);
        }
    }
}

sub usage {
    print STDERR <<'EOF';
Usage:

    nofake-split.pl [file] ...

    examples:

        nofake-split.pl nofake.nw | perl -lne'next unless m{^[0-9a-f]*_1}; print'

        nofake-split.pl nofake.nw | perl -lne'next unless m{^[0-9a-f]*_1: (.*)$}; print($1)'

        nofake-split.pl nofake.nw | perl -lne'next unless m{^[0-9a-f]*_1: <<(.*)>>=\s*$}; print($1)'

        nofake-split.pl nofake.nw | perl -lne'
            do { print ; next } if m{^${id}_2: }; last if $id;
            next unless m{^([0-9a-f]*)_1: <<(.*)>>=\s*$};
            $id=$1 if $2 eq q{usage text}'
EOF
}

my @files = ();

while ($_ = shift(@ARGV)) {
    if (/^--error$/) { $carp_or_croak = \&Carp::croak; }
    elsif (/^(-.+)$/) { usage($1); exit(1) }
    else { push(@files, $_) }
}

read_file($_) for @files;
