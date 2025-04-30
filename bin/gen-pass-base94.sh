#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

usage_text="usage: ${0##*/} NUMBER_OF_CHARS"

nchars=${1:-}; if [ -n "${nchars}" ]; then shift; else die 1 "${usage_text}"; fi

"${thisdir}/u33to126.sh" | head -n "${nchars}" | perl -lne'$acc.=$_}{print$acc'
