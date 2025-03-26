#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -gt 0 ] || die 1 "usage: ${0##*/} file1 file2 ..."

for i in ${1+"$@"}; do
    if ! test -f "$i"; then
        echo "error: file [$i] not found"
        continue
    fi

    # first format
    if echo "$i" | egrep '^[0-9]{8}T[0-9]{6}-' 2>&1; then
        echo "info: skipping [$i]" 1>&2
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

    # there was a brief period that the format
    # "{basename}_{sum}_{filelocalstamp}.{ext}" was used
    if perl -le'exit($ARGV[0] !~ m{_[0-9a-f]{7}_2\d\d\d-[01]\d-\d\d_[012]\dh\d\dm\d\d(?:\.|$)})' -- "${basename}"; then
        echo "info: skipping \"${i}\""
        continue
    fi

    if perl -le'exit($ARGV[0] !~ m{_2\d\d\d-[01]\d-\d\d_[012]\dh\d\dm\d\d_[0-9a-f]{7}(?:\.|$)})' -- "${basename}"; then
        echo "info: skipping \"${i}\""
        continue
    fi

    sum=`sha1sum "$i" | perl -lne'chomp;print(substr($_,0,7));last'`

    filelocalstamp=`perl -MPOSIX=strftime -e'print(strftime(q{%Y-%m-%d_%Hh%Mm%S}, localtime((stat($ARGV[0]))[9])))' -- "$i"`
    out=${basename_noext}_${filelocalstamp}_${sum}${extsuffix}

    if [ x"${dirname}" != x"${i}" ]; then
        out=${dirname}/${out}
    fi

    if [ -e "${out}" -o -e "${out}.gz" ]; then
        echo 'warn: already exists: "'"${out}"'"'
        continue
    fi

    mv -v "${i}" "${out}"
    chmod a-w "${out}"
    gzip -9 "${out}"
done
