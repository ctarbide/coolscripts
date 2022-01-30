#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
cd "${thispath%/*}"

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

test -x show-config.sh || ./create-config.sh 1>&2
kbdir=`"${thispath%/*}/show-config.sh" coolscripts.kbdir`
test -d "${kbdir}" || die 1 "error: directory not found: ${kbdir}"

perlprint=
if [ x"${PERLPRINT:-}" != x ]; then
    perlprint=${PERLPRINT}
else
    perlprint='print(qq{echo '"${kbdir}"'/$_ | first-line-to-clipboard.sh})}{exit(!$.)'
fi

index_gz=${kbdir}/index.gz

if [ "$#" -eq 1 ]; then
    gzip -dc "${index_gz}" | fgrep -i "$@" | perl -lne"${perlprint}"
elif [ "$#" -gt 1 ]; then
    tmpfile=`temporary_file`
    tmpfiles="${tmpfiles} '${tmpfile}'"

    first=$1; shift
    gzip -dc "${index_gz}" | fgrep -i "${first}" > "${tmpfile}" || true # 'true' prevents fgrep from exiting
    for i in "$@"; do
        cat "${tmpfile}" | fgrep -i "${i}" > "${tmpfile}0" || true # 'true' prevents fgrep from exiting
        mv "${tmpfile}0" "${tmpfile}"
    done
    cat "${tmpfile}" | perl -lne"${perlprint}"
    rm -f "${tmpfile}"
else
    gzip -dc "${index_gz}" | perl -lne"${perlprint}"
fi
