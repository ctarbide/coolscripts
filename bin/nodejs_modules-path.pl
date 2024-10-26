#!/usr/bin/env perl

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use strict;
use warnings FATAL => 'uninitialized';
use 5.008; # perl v5.8.0 was released on July 18, 2002
use Carp ();
$SIG{__DIE__} = \&Carp::confess;

use Data::Dumper qw(Dumper);

use File::Spec::Functions qw(rel2abs canonpath);

local $\ = "\n";

(my $progname = $0) =~ s,^.*/(.*),$1,;

my $option_list = 0;      # list one by line instead of PATH format
my $option_reverse = 0;   # reverse the order: root first
my $option_nm_only = 0;   # check for node_modules instead of node_modules/.bin

my @args = ();

#print(Dumper(\@ARGV));

for (grep { m{^\-} || do { push(@args, $_); 0 } } @ARGV) {
    $option_list = 1 if $_ eq '-l';
    $option_reverse = 1 if $_ eq '-r';
    $option_nm_only = 1 if $_ eq '-n';
}

#print(Dumper(\@args));
#print(Dumper({list=>$option_list,reverse=>$option_reverse,nm_only=>$option_nm_only}));

if ($#args < 0) {
    my $extended_help = join(
        '', map {"\t$_\n"} (
            '',
            join('', "example: ", $progname, ' /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'),
        ));
    Carp::confess("usage: $progname path\n" . $extended_help . "\n\t\t");
}

my $dirtest = $option_nm_only ? 'node_modules' : 'node_modules/.bin';

my $startdir = canonpath(rel2abs('.'));
$startdir =~ s,/$,,;

my $i = $startdir;

my @res = ();

while ($i) {
    #print(Dumper({i=>$i}));
    if ( -d "${i}/${dirtest}" ) {
        push(@res, $i);
    }
    $i =~ s,^(.*)/.*,$1,;
}

@res = reverse(@res) if $option_reverse;

#print(Dumper(@res));

if ($option_list) {
    print for map {"${_}/${dirtest}"} @res;
    print for map { split(q{:},$_,-1) } @args;
} elsif (@res) {
    print(join(':', map {"${_}/${dirtest}"} @res), ':', join(':', @args));
} else {
    print(join(':', @args));
}

exit 0;
