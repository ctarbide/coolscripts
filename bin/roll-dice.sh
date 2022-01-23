#!/bin/sh
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
# 0..215 equals 6^3 possibilities
"${thispath%/*}/random-bytes.sh" | perl -lne'$x = $_; next if $x > 215; print for ($x % 6, $x / 6 % 6, $x / 36 % 6)'
