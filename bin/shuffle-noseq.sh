#!/bin/sh
set -eu
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
    die 1 "Error, standard input is reserved for lines that will be shuffled."
fi

if [ x"${key}" = x ]; then
    die 1 "Error, missing key."
fi

if [ ! -r "${key}" ]; then
    die 1 "Error, key does not exist or cannot be read."
fi
"${thisdir}/random-prefix-noseq.sh" -k "${key}" | LC_ALL=C sort -s -k 1,1 | perl -lpe's,^.*?\t,,'
