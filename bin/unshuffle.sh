#!/bin/sh
set -eu

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

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

key=

while [ $# -gt 0 ]; do
    case "${1}" in
        -k|--key) key=${2}; shift ;;
        --key=*) key=${1#*=} ;;
        -k*) key=${1#??} ;;

        --) ;; # no-op
        *)
            echo "${0##*/}: Unrecognized option '${1}'." 1>&2
            exit 1
            ;;
    esac
    shift
done

if [ x"${key}" = x- ]; then
    die 1 "Error, standard input is reserved for lines that will be unshuffled."
fi

if [ x"${key}" = x ]; then
    die 1 "Error, missing key."
fi

if [ ! -r "${key}" ]; then
    die 1 "Error, key does not exist or cannot be read."
fi

slurp_to=`temporary_file`
tmpfiles="${tmpfiles:+${tmpfiles} }'${slurp_to}'"

cat > "${slurp_to}"

perl -le'while(<STDIN>){print(q{})}' < "${slurp_to}" | "${thisdir}/random-prefix.sh" -k "${key}" |
    LC_ALL=C sort | perl -e'while(<STDIN>){chomp;print($_,scalar(<ARGV>))}' -- "${slurp_to}" |
    LC_ALL=C sort -k 2,2 | perl -lpe's,^.*?\t.*?\t,,'
