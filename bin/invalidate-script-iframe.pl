#!/usr/bin/env perl

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use warnings;
use strict;

sub touch_r {
    my ($ref, $file) = @_;
    my @st = stat($ref) or die qq{stat("${ref}"): $!};
    utime($st[8], $st[9], $file) or die qq{utime("${file}"): $!};
}

if (@ARGV) {
    @ARGV = grep {
        if (-f "${_}.orig.gz") {
            print "skip $_: ${_}.orig.gz already exist\n";
            0;
        } elsif (-f "${_}.orig") {
            die "error: ${_}.orig shouldn't exist\n";
        } else {
            1;
        }
    } @ARGV;
    exit 1 if !@ARGV;
    my @ARGV_copy = @ARGV;
    local $^I = ".orig";
    local $/ = undef; # slurp
    while (<>) {
        s,<script\W(?:.|[\n\r])*?</script\s*>,,mig;
        s,<iframe\W(?:.|[\n\r])*?</iframe\s*>,,mig;
        s,<object\W(?:.|[\n\r])*?</object\s*>,,mig;
        print;
    }
    for my $f (@ARGV_copy) {
        next unless -f "${f}.orig";
        system('gzip', "${f}.orig") == 0 or die "system: $?";
        touch_r("${f}.orig.gz", "${f}");
    }
} else {
    print "usage: invalidate-script-iframe.pl file.html ...\n";
}

exit 0;
