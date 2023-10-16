#!/bin/sh
set -eu
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
configname="${thisdir}/coolscripts.cfg"
configure(){ git config -f "${configname}" "$@"; }
[ -f "${configname}" ] || "${thisdir}/create-config.sh"
if [ $# -eq 0 ]; then
    configure --get-regexp '.*'
else
    configure "$@"
fi
