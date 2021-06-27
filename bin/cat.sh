#!/bin/sh

set -eu

die(){ ev=${1}; shift; for msg in "${@}"; do echo "${msg}"; done; exit "${ev}"; }

[ "${#}" -eq 1 ] || die 1 "usage: ${0##*/} compressed-file"

file=${1}
shift

case "${file}" in
    *.gz) cmd='gzip -dc';;
    *.tgz) cmd='gzip -dc';;
    *.bz2) cmd='bzip2 -dc';;
    *.xz) cmd='xz -dc';;
    *.lz) cmd='lzip -dc';;
    *)
	echo "error: unknown file extension [${file}])" 1>&2
	false
	;;
esac

exec ${cmd} "${file}"
