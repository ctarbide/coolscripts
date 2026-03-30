#!/usr/bin/env perl
#
# usage example:
#
#   $ ./prefixed-stdout.pl 'this is my prefix: ' ~/showargs-nl a 'b c' ' ${d} '
#   this is my prefix: [0:/home/user01/showargs-nl]
#   this is my prefix: [1:a]
#   this is my prefix: [2:b c]
#   this is my prefix: [3: ${d} ]
#
#

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use 5.006; # perl v5.6.0 was released on March 22, 2000
use strict;
use warnings FATAL => qw{uninitialized void inplace};
use Carp ();
$SIG{__DIE__} = \&Carp::confess;

local $\ = "\n";

Carp::croak("no prefix informed") unless @ARGV;

my $prefix = shift(@ARGV);

Carp::croak("no arguments to run") unless @ARGV;

open(my $fh, '-|', @ARGV) or die $!;
for (<$fh>) {
    chomp;
    print($prefix,$_);
}
close($fh) or Carp::carp "Cannot close $fh: $!";
