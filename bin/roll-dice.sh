#!/bin/sh
# 0..215 equals 6^3 possibilities
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
"${thisdir}/random-bytes.sh" | perl -lne'$x = $_; next if $x > 215; print(join(qq{\n}, $x % 6, $x / 6 % 6, $x / 36 % 6))'
