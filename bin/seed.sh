#!/bin/sh
set -eu
exec perl -MTime::HiRes=time,clock -le'
    sub seed () {
        $a = clock;
        $b = $a + 1e-4;
        $c = 0;
        while (clock < $b) { $c++; }
        sprintf(qq{%s\t%s\t%s\t%.9f\t%.9f\t%s}, getppid, $$, ++$n, time, $a, $c)
    }
    if ($ARGV[0] =~ /^(\d+)$/) {
        $times = $1;
        while ($times--) { print(seed); }
    } else {
        while (1) { print(seed) }
    }
' -- "$@"
