#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

usage_text="usage: ${0##*/} NUMBER_OF_WORDS"

nwords=${1:-}; if [ -n "${nwords}" ]; then shift; else die 1 "${usage_text}"; fi

# exit(0) = exit(success)
if ! perl -le'exit($ARGV[0] !~ m{^\d+$})' -- "${nwords}"; then
    die 1 "error: wrong argument" "${usage_text}"
fi

if [ "${nwords}" -le 0 ]; then
    die 1 "error: nwords must be greater than 0" "${usage_text}"
fi

if [ x"`gzip -dc "${thisdir}/eff_short_wordlist_2_0.txt.gz" | sha256sum - | head -n1 | cut -b 1-64`" != x"22b45c52e0bd0bbf03aa522240b111eb4c7c0c1d86c4e518e1be2a7eb2a625e4" ]; then
    die 1 "error: invalid words list of failed to check words list integrity"
fi

"${thisdir}/roll-dice.sh" | head -n$((4*nwords)) | THISDIR="${thisdir}" perl -wle'use strict;
my @all = ();
while (<STDIN>) { chomp; push(@all, $_ + 1) }
my %words;
{ open(my $fh, q{-|}, qw{gzip -dc}, $ENV{THISDIR} . q{/eff_short_wordlist_2_0.txt.gz}) or die $!;
  while (<$fh>) { chomp; my @F = split; $words{$F[0]} = $F[1] }
  close($fh) or die $! }
my @words = ();
my $nwords = $ARGV[0];
for my $i (0..$nwords-1) {
  my $wordnum = join(q{}, @all[($i*4)..($i*4+3)]);
  my $word = $words{$wordnum};
  push(@words, $word);
  print(qq{word }, $i+1, qq{ $word ($wordnum)});
}
print(join(q{ }, @words));
' -- "${nwords}"

if which bc >/dev/null 2>&1; then
    echo "bit entropy is log(6^(4*${nwords}))/log(2): `echo "l(6^(4*${nwords}))/l(2)" | bc -l` bits"
else
    echo "bit entropy is log(6^(4*${nwords}))/log(2)"
fi
