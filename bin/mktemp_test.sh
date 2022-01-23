#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

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

tmpfile=`temporary_file`

# 0:exit, 1:hup, 2:int, 3:quit, 15:term
trap "rm -f -- '${tmpfile}'" 0 1 2 3 15

ls -lh "${tmpfile}"

date > "${tmpfile}"

cat "${tmpfile}"

echo done
