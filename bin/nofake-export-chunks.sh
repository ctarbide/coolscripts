#!/bin/sh
set -eu
# usage example: nofake-export-chunks.sh 'usage text' < nofake.nw
# reference: nofake-htmlify-chunk.sh
nofake-split.pl - | perl -le'
    my %chunks = map {$_ => 0} @ARGV;
    my $id;
    while (<STDIN>) {
        chomp;
        do { print($1); next } if $id and m{^${id}_[12]: (.*)};
        print(qq{@\n}) if $id;
        undef $id;
        next unless m{^([0-9a-f]*)_1: <<(.*)>>=\s*$};
        do {
            $id=$1;
            print(qq{<<${2}>>=});
            $chunks{$2}++;
        } if defined($chunks{$2});
    }
    my @not_found_chunks = ();
    for my $chunk (keys(%chunks)) {
        push(@not_found_chunks, $chunk) unless $chunks{$chunk};
    }
    die q{Error, chunks [} . join(q{, }, @not_found_chunks) .
        q{] do not exist.} if @not_found_chunks;
' -- "$@"
