#!/bin/sh
set -eu
exec perl -MConfig -MTime::HiRes=time,clock -MScalar::Util=refaddr -le'
    my $seed_const = sprintf(qq{[%s]\t%s:%s:%s}, $Config{cf_time}, getppid, $$, refaddr(\%ENV));
    my $seed_ccnt = 0;
    my $n = 0;
    open(RNG,q{<},q{/dev/urandom}) or die;
    sub sysrng64bit () {
        read(RNG, $_, 8);
        die unless length == 8;
        unpack(q{H*}, $_);
    }
    sub seed () {
        my $a = clock;
        my $b = $a + 1e-4;
        while (clock < $b) { $seed_ccnt++; }
        sprintf(qq{%s\t%s\t%.9f\t%.9f\t%s\t%s}, $seed_const, ++$n, time, $a, $seed_ccnt, sysrng64bit)
    }
    if ($ARGV[0] =~ /^(\d+)$/) {
        my $times = $1;
        die "Error, too low entropy." if $times < 64;
        while ($times--) { print(seed) }
    } else {
        while (1) { print(seed) }
    }
' -- "$@"
