#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
cd "${thispath%/*}"

test -x show-config.sh || make 1>&2
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
    tmpdir=/run/user/`id -u`
    if [ ! -d "${tmpdir}" ]; then
        die 1 "error: dir ${tmpdir} not found"
    fi
    tmpfile=${tmpdir}/Pictures-find$$.tmp
    first=$1; shift
    gzip -dc "${index_gz}" | fgrep -i "${first}" > "${tmpfile}"
    for i in "$@"; do
        cat "${tmpfile}" | fgrep -i "${i}" > "${tmpfile}0" || true # 'true' prevents fgrep from exiting
        mv "${tmpfile}0" "${tmpfile}"
    done
    cat "${tmpfile}" | perl -lne"${perlprint}"
    rm -f "${tmpfile}"
else
    gzip -dc "${index_gz}" | perl -lne"${perlprint}"
fi
