#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

if [ -t 1 ]; then
    die 1 "Error, this is not supposed to output to a terminal."
fi

key=
args=

while [ $# -gt 0 ]; do
    case "${1}" in
        -k|--key) key=${2}; shift ;;
        --key=*) key=${1#*=} ;;
        -k*) key=${1#??} ;;

        -) args="${args:+${args} }'-'" ;;
        --) ;;
        -*)
            echo "${0##*/}: Unrecognized option '${1}'." 1>&2
            exit 1
            ;;
        *) args="${args:+${args} }'${1}'" ;;
    esac
    shift
done

set --

if [ x"${key}" != x ]; then
    args="${args:+${args} }'${key}'"
fi

eval "set -- "'"$@"'" -- ${args}"

exec perl -MDigest::SHA=sha512 -0777 -e'
    $_ = <>;
    $k = length($_).qq{:${_},};
    while (++$n) {
        print(sha512(qq{${k}${n}}));
    }' "$@"
