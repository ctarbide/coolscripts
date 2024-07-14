#!/bin/sh
exec perl -MURI::Escape -lne'
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
        $s = qq{\047} . uri_unescape($s) . qq{\047};
        $s =~ s,^\047\047|\047\047$,,g;
        print $s;
    } else {
        print qq{\047\047};
    }
}gex' -- "$@"
