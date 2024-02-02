#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
for arg; do
    test -f "${arg}" || die 1 "Error, file \"${arg}\" not found." 1>&2
    printf -- '## [`%s`](%s)\n\n' "${arg}" "${arg}"
    name=${arg##*/}
    printf -- "![%s](%s \"%s\")\n\n----\n\n" ${name} ${arg} ${name}
done
