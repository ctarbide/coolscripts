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

u0Aa(){ "${thisdir}/u0Aa.sh" | head -n"${1}" | perl -pe chomp; }
r0Aa(){ "${thisdir}/r0Aa.sh" | head -n"${1}" | perl -pe chomp; }

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

key=-
args=

slurp_to=

while [ $# -gt 0 ]; do
    case "${1}" in
        -k|--key) key=${2}; shift ;;
        --key=*) key=${1#*=} ;;
        -k*) key=${1#??} ;;

        -)  slurp_to=`temporary_file`
            tmpfiles="${tmpfiles:+${tmpfiles} }'${slurp_to}'"
            args="${args:+${args} }'${slurp_to}'"
            ;;
        --) ;; # no-op
        -*)
            echo "${0##*/}: Unrecognized option '${1}'." 1>&2
            exit 1
            ;;
        *) args="${args:+${args} }'${1}'" ;;
    esac
    shift
done

if [ x"${args}" = x ]; then
    slurp_to=`temporary_file`
    tmpfiles="${tmpfiles:+${tmpfiles} }'${slurp_to}'"
    args="${args:+${args} }'${slurp_to}'"
fi

if [ x"${slurp_to}" != x ]; then
    if [ x"${key}" = x- ]; then
        key=${slurp_to}
    fi
    cat > "${slurp_to}"
fi

eval "set -- ${args}"

"${thisdir}/random-prefix.sh" -k "${key}" | "${thisdir}/paste.pl" -- - "$@" |
    LC_ALL=C sort | perl -lpe's,^.*?\t.*?\t,,'
