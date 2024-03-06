#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .input
SH=${SH:-sh}; export SH
PERL=${PERL:-perl}; export PERL
SUFFIX=${SUFFIX:-/download}; export SUFFIX
INCLUDEPREFIX=${INCLUDEPREFIX:-yes}; export INCLUDEPREFIX
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu
exit 1

<<prog>>=
thisprog=${1}; shift # the initial script
<<slurp to .input>>
set -- "${thisprog}" --aa-- "${0}.input"
nofake-exec.sh --error -Rfilter-out-extraneous-suffixes "$@" -- "${PERL}" |
    LC_ALL=C sort -u
@

Must slurp and save input because two passes are needed.

<<slurp to .input>>=
cat -- "$@" >"${0}.input"
@

<<filter-out-extraneous-suffixes>>=
use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => qw{uninitialized void inplace};

local $\ = "\n";

my $suffix = $ENV{SUFFIX};

my @prefixes;
my %prefixes;

my @saveargs = @ARGV;

while (<>) {
    chomp;
    $_ = $1 if m{^\047(.*)\047$};
    if (m{^(.*)\Q${suffix}\E$}) {
        push(@prefixes, $1);
    }
}

if ($ENV{INCLUDEPREFIX} eq 'yes') {
    print "'${_}'" for @prefixes;
}

@ARGV = @saveargs;
LINE: while (<>) {
    chomp;
    $_ = $1 if m{^\047(.*)\047$};
    next if m{^(.*)\Q${suffix}\E$};
    for my $prefix (@prefixes) {
        next LINE if <<starts with ${prefix}>>;
    }
    print "'${_}'";
}
@

<<starts with ${prefix}>>=
rindex($_, $prefix, 0) == 0
@
