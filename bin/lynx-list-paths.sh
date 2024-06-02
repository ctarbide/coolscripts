#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .input
SH=${SH:-sh -eu}; export SH
PERL=${PERL:-perl}; export PERL
exec nofake-exec.sh --error -Rprog "$@" -- ${SH}
exit 1

<<prog>>=
thisprog=${1}; shift # the initial script
<<slurp to .input>>
set -- "${thisprog}" --aa-- "${0}.input"
nofake-exec.sh --error -Rlynx-list-paths "$@" -- "${PERL}" | LC_ALL=C sort -u
@

Must slurp and save input because two passes are needed.

<<slurp to .input>>=
cat -- "$@" >"${0}.input"
@

<<lynx-list-paths>>=
use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => qw{uninitialized void inplace};
use Carp ();

local $\ = "\n";

my %dirs;

my @args = @ARGV;

Carp::croak("Error, no input file") unless @args;

# STDIN is a pipe and cannot be rewinded/reopened
Carp::croak("Error, input file cannot be standard input") if grep { $_ eq '-' } @args;

@ARGV = @args;
while (<>) {
    chomp;
    next unless m{^ \s* \d+ \. \s+ ([hf][tps]+ :// .*) $}xi;
    $_ = $1;
    s,^(.*/)(.*?)$,${1},;               # dirname
    s,\+,%2B,g;                         # + -> %2b
    $dirs{${1}}++;
}

print "'${_}'" for keys %dirs;

@ARGV = @args;
while (<>) {
    chomp;
    s,#.+$,,;
    next unless m{^ \s* \d+ \. \s+ ([hf][tps]+ :// .* [^/]) $}xi;
    unless ($dirs{"${1}/"}) {
        print "'${1}'";
    }
}
@
