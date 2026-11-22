#!/bin/sh
exec perl -CS -wpe'
BEGIN {
    %map = (
        amp  => q{&},
        lt   => q{<},
        gt   => q{>},
        quot => qq{\042},
        apos => qq{\047},
        nbsp => qq{\x{00A0}},
    );
}
s/(&(?:#(\d+)|#x([0-9a-f]+)|([a-z]+));)/
    defined $2 ? chr($2) :
    defined $3 ? chr(hex($3)) :
    exists $map{lc $4} ? $map{lc $4} : $1
/gei;
' -- "$@"
