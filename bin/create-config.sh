#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

tmpfiles=

rm_tmpfiles(){
    eval "set -- ${tmpfiles}"
    rm -f -- "$@"
}

# 0:exit, 1:hup, 2:int, 3:quit, 15:term
trap 'rm_tmpfiles' 0 1 2 3 15

temporary_file(){
    if type mktemp >/dev/null 2>&1; then
        tmpfile=`mktemp`
    elif type roll-2dice.sh >/dev/null 2>&1; then
        tmpfile="/tmp/tmp.`roll-2dice.sh 0a | head -n12 | perl -pe chomp`"
        ( umask 0177; : > "${tmpfile}" )
    else
        die 1 'error: mktemp not found'
    fi
    echo "${tmpfile}"
}

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

tmpfile=`temporary_file`
tmpfiles="${tmpfiles} '${tmpfile}'"

echo '<<CONFIGNAME>>=' >> "${tmpfile}"
echo "${configname}" >> "${tmpfile}"
echo '@' >> "${tmpfile}"

NOFAKE="${thisdir}/nofake" "${thisdir}/nofake.sh" -Rshow-config.sh -oshow-config.sh \
    "${tmpfile}" show-config.nw

chmod a+x,a-w show-config.sh
