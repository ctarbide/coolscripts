#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -gt 0 ] || die 1 "usage: ${0##*/} file1 file2 ..."

if ! command -v iconv >/dev/null 2>&1; then
    die 1 'Error, "iconv" program not found.'
fi

for i in ${1+"$@"}; do
    if [ -d "${i}" ]; then
        continue
    fi

    if [ ! -r "$i" ]; then
        continue
    fi

    if perl -le'exit 1 unless $ARGV[0] =~ m{\. (?: dll | exe | pdf | gif | png | jpg ) $}xi' -- "${i}" ; then
        continue
    fi

    bom=`perl -e'read(STDIN,$_,2);printf(qq{%04x\n},unpack(q{n},$_))' <"${i}"`
    if [ x"${bom}" != xfffe -a x"${bom}" != xfeff ]; then
        continue
    fi

    echo "${i}"
done
