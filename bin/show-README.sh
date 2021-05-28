#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
cd "${thispath%/*}"

test -x show-config.sh || make 1>&2
kbdir=`"${thispath%/*}/show-config.sh" coolscripts.kbdir`
test -d "${kbdir}" || die 1 "error: directory not found: ${kbdir}"

tmpdir=/run/user/`id -u`
if [ ! -d "${tmpdir}" ]; then
    die 1 "error: dir ${tmpdir} not found"
fi
tmpfile=${tmpdir}/Pictures-show-README$$.tmp

trap "rm -f \"${tmpfile}\"" 0 1 2 3 4 9 11 13 15

PERLPRINT="print('${kbdir}/' . \$_)" ./find.sh "$@" | perl -lne'($path = $_ . q{/README.txt}) =~ s,~/,$ENV{HOME}/,; print($path) if -e $path' > "${tmpfile}"

if [ -s "${tmpfile}" ]; then
    for i in `cat "${tmpfile}"`; do
        grep -EH '.?' "${i}"
    done
else
    echo "no results"
fi
