#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
cd "${thispath%/*}"

temporary_file(){
    if type mktemp >/dev/null 2>&1; then
        mktemp
    elif type roll-2dice.sh >/dev/null 2>&1; then
	tmpfile="/tmp/tmp.`roll-2dice.sh 0a | head -n12 | perl -pe chomp`"
	( umask 0177; : > "${tmpfile}" )
	echo "${tmpfile}"
    else
        die 1 'error: mktemp not found'
    fi
}

test -x show-config.sh || ./create-config.sh 1>&2
kbdir=`"${thispath%/*}/show-config.sh" coolscripts.kbdir`
test -d "${kbdir}" || die 1 "error: directory not found: ${kbdir}"

tmpfile=`temporary_file`

# 0:exit, 1:hup, 2:int, 3:quit, 15:term
trap "rm -f -- '${tmpfile}'" 0 1 2 3 15

PERLPRINT="print('${kbdir}/' . \$_)" ./find.sh "$@" | perl -lne'($path = $_ . q{/README.txt}) =~ s,~/,$ENV{HOME}/,; print($path) if -e $path' > "${tmpfile}"

nlines=${NLINES:-20}
unset NLINES

if [ -s "${tmpfile}" ]; then
    for i in `cat "${tmpfile}"`; do
        echo "################################################################ showing first ${nlines} of ${i}"
        head -n"${nlines}" "${i}"
        echo
    done
else
    echo "no results"
fi
