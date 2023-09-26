#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

tmpfiles=

rm_tmpfiles(){
    eval "set -- ${tmpfiles}"
    rm -fv -- "$@"
}

# 0:exit, 1:hup, 2:int, 3:quit, 15:term
trap 'rm_tmpfiles' 0 1 2 3 15

u0Aa(){ ./u0Aa.sh | head -n"${1}" | perl -pe chomp; }
r0Aa(){ ./r0Aa.sh | head -n"${1}" | perl -pe chomp; }

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

echo "**** a: [${tmpfiles}]"

tmpfile=`temporary_file`
tmpfiles="${tmpfiles:+${tmpfiles} }'${tmpfile}'"
echo "**** b: [${tmpfiles}]"

tmpfile=`temporary_file`
tmpfiles="${tmpfiles:+${tmpfiles} }'${tmpfile}'"
echo "**** c: [${tmpfiles}]"

date > "${tmpfile}"

cat "${tmpfile}"

eval "set -- ${tmpfiles}"
ls -lh "$@"

echo done
