#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

cd "${thisdir}"

configname=coolscripts.cfg

rm -fv "${configname}.tmp"

# use 'git config' as a generic configuration tool
configure(){ git config -f "${configname}.tmp" "$@"; }

# configure

configure coolscripts.configname "${configname}"
configure coolscripts.kbdir "${HOME}/Downloads/Pictures" # knowledge base dir

# generate show-config.sh and "${configname}"

rm -f show-config.sh "${configname}"

mv "${configname}.tmp" "${configname}"
chmod a+x,a-w "${configname}"

echo "generated from ${0##*/}" > tmp.nw
echo '<<CONFIGNAME>>=' >> tmp.nw
echo "${configname}" >> tmp.nw
echo '@' >> tmp.nw

NOFAKE="${thisdir}/nofake" "${thisdir}/nofake.sh" -Rshow-config.sh -oshow-config.sh \
    tmp.nw show-config.nw

chmod a+x,a-w show-config.sh
