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

echo "**** a: [${tmpfiles}]"

tmpfile=`temporary_file`
tmpfiles="${tmpfiles} '${tmpfile}'"
echo "**** b: [${tmpfiles}]"

tmpfile=`temporary_file`
tmpfiles="${tmpfiles} '${tmpfile}'"
echo "**** c: [${tmpfiles}]"

date > "${tmpfile}"

cat "${tmpfile}"

eval "set -- ${tmpfiles}"
ls -lh "$@"

echo done
