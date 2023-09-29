#!/bin/sh
set -eu
exec perl -MTime::HiRes=time,clock -MDigest::SHA=sha256,sha512 -e'
    sub seed () {
        $a = clock;
        $b = $a + 1e-4;
        $c = 0;
        while (clock < $b) { $c++; }
        sprintf(qq{%s\t%s\t%s\t%.9f\t%.9f\t%s}, getppid, $$, ++$n, time, $a, $c)
    }
    while (1) {
        $s = sha256(join(qq{\n}, map {seed} 1..64));
        $k = length($s).qq{:${s},};
        for $n (1..65536) {
            print(sha512(qq{${k}${n}}));
        }
    }
'
