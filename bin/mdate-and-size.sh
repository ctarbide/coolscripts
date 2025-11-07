#!/bin/sh
#
# reference: dir-info-analyse.sh
# input: find -type f
#
#

set -eu

LC_ALL=C
export LC_ALL

exec perl -lne'
    s,^\./,,;
    @s = stat;
    ($s,$n,$h,$d,$m,$y) = localtime($s[9]);
    printf(qq{%04d-%02d-%02d_%02dh%02dm%02d %12.12s %s\n},
        $y+1900, $m+1, $d,
        $h, $n, $s,
        $s[7], $_);
'
