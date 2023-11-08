#!/bin/sh
set -eu
exec perl -MConfig -MTime::HiRes=time,clock -MScalar::Util=refaddr -MDigest::SHA=sha512 -e'
    my $seed_const = sprintf(qq{[%s]\t%s:%s:%s}, $Config{cf_time}, getppid, $$, refaddr(\%ENV));
    my $seed_ccnt = 0;
    my $n = 0;
    sub seed () {
        my $a = clock;
        my $b = $a + 1e-4;
        while (clock < $b) { $seed_ccnt++; }
        sprintf(qq{%s\t%s\t%.9f\t%.9f\t%s}, $seed_const, ++$n, time, $a, $seed_ccnt)
    }
    while (1) {
        my $s = sha512(join(qq{\n}, map {seed} 1..64));
        my $k = length($s).qq{:${s},};
        for my $n (1..1048576) {
            print(sha512(qq{${k}${n}}));
        }
    }
'
