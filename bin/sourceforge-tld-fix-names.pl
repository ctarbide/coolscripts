#!/usr/bin/env perl

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => 'uninitialized';
use Carp ();
$SIG{__DIE__} = \&Carp::confess;

use File::Find ();

local $\ = "\n";

my @files = get_files('sourceforge-tld');

print('found ', scalar(@files), ' files elegible to rename');

for my $a (@files) {
    (my $b = $a) =~ s,\?viasf=\d+$,,i;
    if (-f $b) {
        print("WARNING: \"${b}\" also exists, skipping rename");
    } else {
        print("renaming \"${a}\"");
        rename($a, $b);
    }
}

exit 0;

####

sub get_files {
    my ($hostdir) = @_;
    my @files;
    my $wanted = sub {
        return if -d $_;
        if (m{\?viasf=1$}) {
            push @files, $_;
        }
    };
    File::Find::find({
        wanted => $wanted,
        follow => 0,
        no_chdir => 1,
    }, $hostdir);
    return @files;
}
