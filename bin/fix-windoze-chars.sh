#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -gt 0 ] || die 1 "usage: ${0##*/} file1 file2 ..."

if ! command -v iconv >/dev/null 2>&1; then
    die 1 'Error, "iconv" program not found.'
fi

for i in ${1+"$@"}; do
    if [ -d "${i}" ]; then
        echo "skipdir [${i}]"
        continue
    fi

    if [ ! -f "$i" ]; then
        echo "Error, file \"$i\" not found."
        continue
    fi

    if [ ! -r "$i" ]; then
        echo "Error, cannot read file \"$i\"."
        continue
    fi

    if perl -le'exit 1 unless $ARGV[0] =~ m{\. (?: dll | exe | pdf | gif | png | jpg ) $}xi' -- "${i}" ; then
        # probably not what is intended
        continue
    fi

    if perl -le'exit($ARGV[0] !~ m{__utf8 \. [\w\-_.]+ $}xi)' -- "${i}"; then
        echo "Info, skipping \"$i\", already converted." 1>&2
        continue
    fi

    bom=`perl -e'read(STDIN,$_,2);printf(qq{%04x\n},unpack(q{n},$_))' <"${i}"`
    if [ x"${bom}" != xfffe -a x"${bom}" != xfeff ]; then
        echo "Info, skipping \"${i}\" (no BOM), probably not an UTF-16 file." 1>&2
        continue
    fi

    dirname=${i%/*}
    basename=${i##*/}
    basename_noext=${basename%%.*}

    ext=${basename#*.}
    extsuffix=
    if [ x"${ext}" = x"${basename}" ]; then
        extsuffix=
    else
        extsuffix=.${ext}
    fi

    out=${basename_noext}__utf8${extsuffix}

    if [ x"${dirname}" != x"${i}" ]; then
        out=${dirname}/${out}
    fi

    if [ -e "${out}" ]; then
        echo 'Warning, already exists: "'"${out}"'", skipping.' 1>&2
        continue
    fi

    echo "doing [${i}] -> [${out}]"

    iconv -f utf-16 -t utf-8 <"${i}" >"${out}"

    dos2unix.pl -ok "${out}"
    rm -f "${out}~"

    perl -lpi -e's,\0,,' "${out}"

    chmod a-w "${out}"
done
