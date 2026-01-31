#!/bin/sh
set -eu
# usage example: nofake-export-chunks.sh 'usage text' < nofake.nw
# reference: nofake-htmlify-chunk.sh
prefix=${PREFIX:-}
nofake-split.pl - | perl -sle'
    my %chunks = map {$_ => 0} @ARGV;
    my $id;
    sub write_line ($) { print $_[0]; }
    sub write_line_fix_refs {
        my ($cur, $acc, $chunkref) = ($_[0], q{});
        while ($cur) {
            if ($cur =~ m{^ (|.*?[^\@]) << (.*?[^\@]) >> (|[^>].*?) $}x) {
                $cur = $3;
                $chunkref = $2;
                if (defined $chunks{$chunkref}) {
                    $acc .= $1 . qq{<<${prefix}${chunkref}>>};
                } else {
                    $acc .= $1 . qq{<<${chunkref}>>};
                }
            } else {
                $acc .= $cur;
                last;
            }
        }
        print $acc;
    }
    my $handle_line = $prefix ? \&write_line_fix_refs : \&write_line;
    while (<STDIN>) {
        chomp;
        do { $handle_line->($1); next } if $id and m{^${id}_[12]: (.*)};
        print qq{@} if $id;
        undef $id;
        next unless m{^([0-9a-f]*)_1: <<(.*)>>=\s*$};
        do {
            $id=$1;
            print(qq{<<${prefix}${2}>>=});
            $chunks{$2}++;
        } if defined($chunks{$2});
    }
    my @not_found_chunks = ();
    for my $chunk (keys(%chunks)) {
        push(@not_found_chunks, $chunk) unless $chunks{$chunk};
    }
    die q{Error, chunks [} . join(q{, }, @not_found_chunks) .
        q{] do not exist.} if @not_found_chunks;
' -- -prefix="${prefix}" "$@"
