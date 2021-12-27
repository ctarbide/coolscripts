#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

startdir=${1:-.}

if [ ! -d "${startdir}" ]; then
    die 1 "error: \"${startdir}\" is not a directory"
fi

startdir=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${startdir}"`

# - do we have a GIT_DIR?
GIT_DIR=
i=@${startdir}
while true; do
    j=${i#@}
    # echo "testing j=[${j}/.git]"
    if [ -d "${j}/.git" ]; then
        GIT_DIR=${j}/.git
        break
    fi
    i=${i%/*}
    if [ "${i}" = @ ]; then
        # reached /
        if [ -d /.git ]; then
            echo '/.git'
        fi
        break
    fi
done

echo "${GIT_DIR}"
