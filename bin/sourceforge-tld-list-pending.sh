#!/bin/sh

# reference: coolscripts/bin/filter-out-existing-urls.sh

# note: listings_curl is the output of 'curl --head -sSL' for a
# standard sourceforge download url

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`
thisdir=${thispath%/*}

LC_ALL=C
export LC_ALL

filter_existing(){
    perl -lne'next if m{/$}; next if m{\?} and !m{\?viasf=1}; print' -- "$@" |
        perl -MCGI::Util=unescape -lne'next if m{%} and m{^\w+://(.*)$} and -f unescape($1); print' |
        perl -MCGI::Util=unescape -lne'next if m{%} and m{^\w+://(.*)(?:\?viasf=\d+)$} and -f unescape($1); print' |
        perl -lne'next if m{^\w+://(.*)$} and -f $1; print' |
        perl -lne'next if m{^\w+://(.*)(?:\?viasf=\d+)$} and -f $1; print' |
        perl -lne'print(qq{\047${_}\047})'
}

list_urls(){
    perl -lpe's,\015+$,,' -- listings_curl |
        perl -lne'next unless m{^Location:\s+(.*)}; next if $1 =~ m{^https://downloads\.sourceforge\.net/}; print($1)' |
        filter_existing
}

list_urls
