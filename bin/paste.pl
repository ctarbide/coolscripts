#!/usr/bin/env perl

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use strict;
use warnings;

my $eofcntstart = 0;

my @files = grep { defined } map {
    my $fh;
    if ($_ eq '--') {
        # no-op
    } elsif ($_ eq '-') {
        $fh = \*STDIN;
        # skip stdin eof, don't wait for it to close
        $eofcntstart++;
    } else {
        open($fh, '<', $_) or die "$!: \"$_\"";
    }
    $fh;
} @ARGV;

my $nfiles = @files;
my $eofcnt = $eofcntstart;
my @fields = ();

while (1) {
    for (@files) {
        my $fh = $$_;
        if (eof($fh)) {
            push(@fields, "");
            $eofcnt++;
        } else {
            chomp(my $s = <$fh>);
            push(@fields, $s);
        }
    }
    if ($eofcnt >= $nfiles) {
        close($$_) for @files;
        last;
    }
    print(join("\t", @fields), "\n");
    $eofcnt = $eofcntstart;
    @fields = ();
}
