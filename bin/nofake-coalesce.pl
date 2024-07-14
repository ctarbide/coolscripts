#!/usr/bin/env perl

# coalesces consecutive chunks of the same name

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => qw{uninitialized void inplace};
use Carp ();
$SIG{__DIE__} = \&Carp::confess;

local $\ = "\n";

my $carp_or_croak = \&Carp::carp;

my $inside_chunk = 0;
my $ndoclines = 0;
my $chunkname = '';
my $endofchunk = '@'; # implicit

sub read_file {
    local @ARGV = @_;
    while (my $line = <>) {
        chomp($line);
        $line =~ s,\015+$,,; # 015 is CR
        if ($line =~ m{^<<(.+?)>>=\s*$}) {
            if ($inside_chunk) {
                die if $endofchunk ne '@'; # assertion
                print $line if $chunkname ne $1;
                next;
            }
            if ($ndoclines or $chunkname ne $1 or $endofchunk ne '@') {
                print $endofchunk if $endofchunk ne '@';
                print $line;
                $endofchunk = '@'; # implicit
            }
            $inside_chunk = 1;
            $ndoclines = 0;
            $chunkname = $1;
            next;
        }
        if ($inside_chunk) {
            if ($line =~ m{^\@(?:$|\s)}) {
                $inside_chunk = 0;
                $endofchunk = $line;
            } else {
                # regular line inside chunk
                $line =~ s,^\@\@,\@,;
                print $line;
            }
            next;
        }
        # first document line after the first chunk
        if ($chunkname and $ndoclines == 0) {
            print $endofchunk;
            $endofchunk = '@'; # implicit
        }
        $ndoclines++;
        print $line;
    }
    # print end of chunk if
    #   - unterminated chunk
    #   - firt documentation line right after a chunk termination
    print $endofchunk if $inside_chunk or ($chunkname and $ndoclines == 0);
}

sub usage {
    print STDERR <<'EOF';
Usage:

    nofake-coalesce.pl [file] ...

EOF
}

my @files = ();

while ($_ = shift(@ARGV)) {
    if (/^--error$/) { $carp_or_croak = \&Carp::croak; }
    elsif (/^(-.+)$/) { usage($1); exit(1) }
    else { push(@files, $_) }
}

read_file($_) for @files ? @files : qw{-};
