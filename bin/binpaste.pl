#!/usr/bin/env perl

# unlike paste.pl, binpaste.pl stops at first eof

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use strict;
use warnings;

my @files = grep { defined } map {
    my $fh;
    if ($_ eq '--') {
        # no-op
    } elsif ($_ eq '-') {
        $fh = \*STDIN;
    } else {
        open($fh, '<', $_) or die "$!: \"$_\"";
    }
    $fh;
} @ARGV;

my $nfiles = @files;
my $eof = 0;
my $out = '';
my $i;
my $c;

while (1) {
    for ($i=0; $i<$nfiles; $i++) {
        my $fh = ${ $files[$i] };
        $eof = eof($fh);
        last if $eof;
        read($fh, $c, 1);
        $out .= $c;
    }
    if ($eof) {
        close($$_) for @files;
        last;
    }
    print($out);
    $out = '';
}
