#!/bin/sh
set -eu
exec perl -MConfig -MTime::HiRes=time,clock -MScalar::Util=refaddr -le'
    my $seed_const = sprintf(qq{[%s]\t%s:%s:%s}, $Config{cf_time}, getppid, $$, refaddr(\%ENV));
    my $seed_ccnt = 0;
    my $n = 0;
    sub seed () {
        my $a = clock;
        my $b = $a + 1e-4;
        while (clock < $b) { $seed_ccnt++; }
        sprintf(qq{%s\t%s\t%.9f\t%.9f\t%s}, $seed_const, ++$n, time, $a, $seed_ccnt)
    }
    if ($ARGV[0] =~ /^(\d+)$/) {
        my $times = $1;
        while ($times--) { print(seed) }
    } else {
        while (1) { print(seed) }
    }
' -- "$@"
