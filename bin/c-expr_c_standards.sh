#!/bin/sh
set -eu
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`
thisdir=${thispath%/*}
last=:
if [ "x${1:-}" != x ]; then
    printf -- '<<%s>>=\n' "${1}"
    last='echo @'
fi
nofake --error -R'c standards' "${thisdir}/c-expr.sh"
${last}
