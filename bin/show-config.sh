#!/bin/sh
set -eu
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
configname="${thisdir}/coolscripts.cfg"
configure(){
    if [ x"${1#*.}" = x"${1}" ] || ! git config -f "${configname}" "$@"; then
        name="coolscripts.${1}"; shift
        git config -f "${configname}" "${name}" "$@"
    fi
}
[ -f "${configname}" ] || "${thisdir}/create-config.sh"
if [ $# -eq 0 ]; then
    git config -f "${configname}" --get-regexp '.*'
else
    configure "$@"
fi
