#!/bin/sh
set -eu
exec perl -MConfig -MTime::HiRes=time,clock -MScalar::Util=refaddr -MDigest::SHA=sha512 -e'
    $seed_const = sprintf(qq{[%s]\t%s:%s:%s}, $Config{cf_time}, getppid, $$, refaddr(\%ENV));
    $seed_ccnt = 0;
    sub seed () {
        $a = clock;
        $b = $a + 1e-4;
        while (clock < $b) { $seed_ccnt++; }
        sprintf(qq{%s\t%s\t%.9f\t%.9f\t%s}, $seed_const, ++$n, time, $a, $seed_ccnt)
    }
    while (1) {
        $s = sha512(join(qq{\n}, map {seed} 1..64));
        $k = length($s).qq{:${s},};
        for $n (1..1048576) {
            print(sha512(qq{${k}${n}}));
        }
    }
'
