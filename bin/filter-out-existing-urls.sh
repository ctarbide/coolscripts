#!/bin/sh
set -eu
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`
thisdir=${thispath%/*}
LC_ALL=C
export LC_ALL
"${thisdir}/filter-out-not-found-urls.sh" "$@" |
    perl -MURI::Escape::XS=uri_unescape -lne'next if m{%} and m{^\w+://(.*)$} and -f uri_unescape($1); print' |
    perl -lne'next if m{^\w+://(.*)$} and -f $1; print'
