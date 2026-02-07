#!/usr/bin/env perl
eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;
use 5.006; # perl v5.6.0 was released on March 22, 2000
use strict;
use warnings FATAL => qw{uninitialized void inplace};
use CGI::Util qw{unescape};
local $\ = "\n";
my ($n, $s, @names, %names) = (q{?},);
my %args = ();
while (<>) {
    chomp;
    if (m{^#name\s+(.*)\s*$}) {
       push(@names, $n = $1);
       next;
    }
    next if m{^\s*#};
    # my $line = $_;
    s,\\\s*$,,;
    s,%,%25,g;
    s,\134\134,%5c%5c,g;
    s,\134\047,%27,g;
    s,\134\042,%22,g;
    s,\134,%5c,g;
    s{
        (?:([^\047\042\s]*)\047) ( .*? ) (?:\047([^\047\042\s]*)) |
        (?:([^\047\042\s]*)\042) ( .*? ) (?:\042([^\047\042\s]*)) |
        ( [^\047\042\s]+ )
    }{
        # print qq{"[1:$1][2:$2][3:$3][4:$4][5:$5][6:$6][7:$7][$line]};
        if (defined($2)) {
            $s = qq{${1}${2}${3}};
        } elsif (defined($5)) {
            my $s4 = $4;
            my $s6 = $6;
            ($s = $5) =~ s,%27|\047,\047\042\047\042\047,g;
            $s = qq{${s4}${s}${s6}};
        } elsif ($7) {
            next if $7 eq q{%5c}; # only a line continuation
            ($s = $7) =~ s,%5c$,,; # remove line continuation, if any
        } else {
            $s = q{exhaustion};
        }
        if ($s) {
            $s = qq{\047} . unescape($s) . qq{\047};
            $s =~ s,^\047\047|\047\047$,,g;
            $s =~ s,;\047$,\047,g;
        } else {
            $s = qq{\047\047};
        }
        if ($s !~ m{^\047(?:set|--|\$\@)\047$}) {
            $names{$n}++;
    $args{$s}++;
        }
    }gex;
}
print for sort keys %args;
