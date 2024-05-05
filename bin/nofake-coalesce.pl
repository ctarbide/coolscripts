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
my $endofchunk = '';

sub read_file {
    local @ARGV = @_;
    while (my $line = <>) {
        chomp($line);
        if ($line =~ m{^<<(.+?)>>=\s*$}) {
            unless ($ndoclines == 0 and $chunkname eq $1 and $endofchunk eq '@') {
                if ($endofchunk) {
                    print($endofchunk);
                    $endofchunk = '';
                }
                $chunkname = $1;
                print($line);
            }
            $inside_chunk = 1;
        } elsif ($inside_chunk) {
            if ($line =~ m{^\@(?:$|\s)}) {
                $inside_chunk = 0;
                $ndoclines = 0;
                $endofchunk = $line;
            } else {
                # regular line inside chunk
                $line =~ s,^\@\@,\@,;
                print($line);
            }
        } else {
            if ($endofchunk) {
                print($endofchunk);
                $endofchunk = '';
            }
            $ndoclines++;
            print($line);
        }
    }
    if ($endofchunk) {
        print($endofchunk);
        $endofchunk = '';
    }
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
