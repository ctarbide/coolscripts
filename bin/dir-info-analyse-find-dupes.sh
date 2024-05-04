#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .input
SH=${SH:-sh -eu}; export SH
PERL=${PERL:-perl}; export PERL
exec nofake-exec.sh --error -Rprog "$@" -- ${SH}
exit 1

This scripts only list files with the same modification time and file size.

Usage example: likely duplicates

    dir-info-analyse.sh . | dir-info-analyse-find-dupes.sh

Usage example: sha256 test

    dir-info-analyse.sh . | dir-info-analyse-find-dupes.sh |
        perl -lane'print($F[2])' | xargs sha256sum

<<prog>>=
thisprog=${1}; shift # the initial script
<<slurp to .input>>
set -- "${thisprog}" --aa-- "${0}.input"
nofake-exec.sh --error -Rfind-dupes "$@" -- "${PERL}" | LC_ALL=C sort -u
@

Must slurp and save input because we need two passes on the file.

<<slurp to .input>>=
cat -- "$@" >"${0}.input"
@

<<find-dupes>>=
use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => qw{uninitialized void inplace};
use Carp ();

local $\ = "\n";

my $carp_or_croak = \&Carp::carp;

my @args = @ARGV;

Carp::croak("Error, no input file") unless @args;

# STDIN is a pipe and cannot be rewinded/reopened
Carp::croak("Error, input file cannot be standard input") if grep { $_ eq '-' } @args;

my %found;
my $stamp;
my $path;
my $basename;
my $key1;
my $key2;

@ARGV = @args;
while (<>) {
    chomp;
    <<set $key1, $key2 and $path>>
    $found{$key1}++;
    $found{$key2}++;
}

my $count;

@ARGV = @args;
while (<>) {
    chomp;
    <<set $key1, $key2 and $path>>
    for my $key ($key1, $key2) {
        $count = $found{$key};
        if ($count > 1) {
            print "${key} ${count} ${path}";
        }
    }
}
@

<<set $key1, $key2 and $path>>=
next unless m{^ ( [^\s]+ ) \s+ (\d+) \s+ (.*) $}x;
$stamp = "${1}:${2}";
($basename = ($path = ${3})) =~ s,.*/,,;
$key1 = "${stamp}::";
$key2 = "${stamp}:${basename}:";
@
