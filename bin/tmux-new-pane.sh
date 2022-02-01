#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
if [ -n "${1:-}" ]; then
    test -d "${1}" || die 1 "error: \"${1}\" is not a directory"
    thisdir=${1}; shift
    thisdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${thisdir}"`
else
    thisdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- .`
fi
exec tmux split-window -c "${thisdir}" "$@"
