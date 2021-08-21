#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

prg=${1:-}

if [ x"${prg}" = x ]; then
    die 1 "error: program not specified" 1>&2
fi

shift

DIR_START=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- .`
BASENAME=${DIR_START##*/}

export DIR_START BASENAME

prog=

i=@${DIR_START}
while true; do
    j=${i#@}
    prog=${j}__${prg}
    if [ -x "${prog}" ]; then break; fi
    prog=
    i=${i%/*}
    if [ "${i}" = @ ]; then
        # reached /
        prog=/${prg}
        if [ -x "${prog}" ]; then break; fi
        prog=
        break
    fi
done

if [ x"${prog}" = x ]; then
    die 1 "error: could not find ${prg}" 1>&2
fi

DIR_FOUND=${i#@}
export DIR_FOUND

exec "${prog}" "$@"
