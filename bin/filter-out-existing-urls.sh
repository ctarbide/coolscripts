#!/bin/sh
set -eu
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`
thisdir=${thispath%/*}
LC_ALL=C
export LC_ALL
"${thisdir}/filter-out-not-found-urls.sh" "$@" |
    perl -lpe's,^\047(.*)\047$,${1},; s,\047,%27,g; s,\+,%2B,g' |
    perl -MCGI::Util=unescape -lne'next if m{%} and m{^\w+://(.*)$} and -f unescape($1); print' |
    perl -lne'next if m{/$}; next if m{^\w+://(.*)$} and -f $1; print qq{\047${_}\047}'
