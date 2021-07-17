#!/bin/sh

# note: listings_curl is the output of 'curl --head -sSL' for a
# standard sourceforge download url

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`
thisdir=${thispath%/*}

list_urls(){
    perl -lpe's,\015+$,,' -- listings_curl |
        perl -lne'next unless m{^Location:\s+(.*)}; next if $1 =~ m{^https://downloads\.sourceforge\.net/}; print($1)'
}

list_domains(){
    list_urls | perl -lne'next if !m{^[hf][tps]+://(.*?)/}; $h{$1}++}{print for keys(%h)'
}

mkdir -p sourceforge-tld

for i in `list_domains`; do
    test -d "${i}" || ln -s sourceforge-tld "${i}"
done
