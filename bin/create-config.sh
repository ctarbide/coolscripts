#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

cd "${thisdir}"

which m4 >/dev/null || die 1 "error: program not found: m4"

configname=coolscripts.cfg

rm -fv "${configname}.tmp"

configure(){ git config -f "${configname}.tmp" "$@"; }

# configure

configure coolscripts.configname "${configname}"
configure coolscripts.kbdir "${HOME}/Pictures" # knowledge base dir

# generate show-config.sh and "${configname}"

rm -f show-config.sh "${configname}"

mv "${configname}.tmp" "${configname}"
chmod a+x,a-w "${configname}"

m4 -DCONFIGNAME="${configname}" show-config.sh.m4 > show-config.sh
chmod a+x,a-w show-config.sh
