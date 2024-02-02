#!/bin/sh
perl -lne'
    print if m{^input args: };
    next if m{^\s*$};
    print if s,^ \s* \d+ \. \s (.*) $,0. ${1},x;
' -- "$@" | LC_ALL=C sort -u
