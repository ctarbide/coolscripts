#!/bin/sh
set -eu
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

u0Aa(){ u0Aa.sh | head -n"${1}" | perl -pe chomp; }
r0Aa(){ r0Aa.sh | head -n"${1}" | perl -pe chomp; }

temporary_file(){
    if command -v mktemp >/dev/null 2>&1; then
        tmpfile=`mktemp`
    elif command -v perl >/dev/null 2>&1 && test -r /dev/urandom; then
        tmpfile="/tmp/tmp.`u0Aa 10`"
        ( umask 0177; : > "${tmpfile}" )
    elif command -v perl >/dev/null 2>&1; then
        tmpfile="/tmp/tmp.`r0Aa 10`"
        ( umask 0177; : > "${tmpfile}" )
    else
        die 1 'error: mktemp not found'
    fi
    echo "${tmpfile}"
}

kbdir=`"${thisdir}/show-config.sh" coolscripts.kbdir`
test -d "${kbdir}" || die 1 "Error, directory not found: ${kbdir}."

tmpfile=`temporary_file`
tmpfiles="${tmpfiles:+${tmpfiles} }'${tmpfile}'"

PERLPRINT="print('${kbdir}/' . \$_)" "${thisdir}/find.sh" "$@" |
    perl -lne'($path = $_ . q{/README.txt}) =~ s,~/,$ENV{HOME}/,; print($path) if -e $path' > "${tmpfile}"

if [ -s "${tmpfile}" ]; then
    for i in `cat "${tmpfile}"`; do
        grep -EH '.?' "${i}"
    done
else
    echo "no results"
fi
