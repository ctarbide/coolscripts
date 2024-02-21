#!/bin/sh
set -eu
# usage example:
#   tar -tzf js185-1.0.0.tar.gz | basic-dir-stats.sh | fgrep jit
#
exec perl -lne'
    s,^(.*)/.*?$,$1,;
    $dirs{$_}++;
}{
    print(qq{$dirs{$_}\t\t${_}/}) for sort(keys(%dirs))
' -- "$@"
