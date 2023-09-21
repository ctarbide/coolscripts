#!/bin/sh
set -eu
exec perl -le'
    $_ = <>; chomp;
    die "Only one input line expected." if <>;
    $k = length($_).qq{:${_},};
    while (++$n) {
        print(qq{${k}${n}});
    }'
