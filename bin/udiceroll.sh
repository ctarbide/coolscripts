#!/bin/sh
# ./udiceroll.sh | head -n1000000 | perl -lne'$c{$_}++}{print($c{$_}) for keys(%c)'
exec perl -l -0777 -Minteger -e'while(read(STDIN,$d,64)){
for $x (unpack(q{C*},$d)) {
    next if $x > 215;
    print($_ % 6) for ($x, $x / 6, $x / 36);
}}'</dev/urandom
