#!/bin/sh
set -eu
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
configname="${thisdir}/coolscripts.cfg"
configure(){ git config -f "${configname}" "$@"; }
configure coolscripts.configname "${configname}"
configure coolscripts.kbdir "${HOME}/Downloads/Pictures"
