#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -gt 0 ] || die 1 "usage: ${0##*/} file1 file2 ..."

for i in ${1+"$@"}; do
    if ! test -f "$i"; then
        echo "error: file [$i] not found"
        continue
    fi

    # first/old format
    if perl -le'exit($ARGV[0] !~ m{^[0-9]{8}T[0-9]{6}-})' -- "${i}"; then
        echo "info: skipping [$i]" 1>&2
        continue
    fi

    dirname=${i%/*}
    basename=${i##*/}

    # there was a brief period that the format
    # "{basename}_{sum}_{filelocalstamp}.{ext}" was used
    if perl -le'exit($ARGV[0] !~ m{_[0-9a-f]{7}_2\d\d\d-[01]\d-\d\d_[012]\dh\d\dm\d\d\.})' -- "${basename}"; then
        echo "info: skipping \"${i}\""
        continue
    fi

    if perl -le'exit($ARGV[0] !~ m{_2\d\d\d-[01]\d-\d\d_[012]\dh\d\dm\d\d_[0-9a-f]{7}\.bak})' -- "${basename}"; then
        echo "info: skipping \"${i}\""
        continue
    fi

    sum=`sha1sum "$i" | perl -lne'chomp;print(substr($_,0,7));last'`

    filelocalstamp=`perl -MPOSIX=strftime -e'print(strftime(q{%Y-%m-%d_%Hh%Mm%S}, localtime((stat($ARGV[0]))[9])))' -- "${i}"`
    out=${basename}_${filelocalstamp}_${sum}.bak

    if [ x"${dirname}" != x"${i}" ]; then
        if [ -d "${dirname}/sandbox/bkp" ]; then
            out=${dirname}/sandbox/bkp/${out}
        else
            out=${dirname}/${out}
        fi
    else
        if [ -d sandbox/bkp ]; then
            out=sandbox/bkp/${out}
        fi
    fi

    if [ -f "${out}" ]; then
        echo 'warn: already exists: "'"${out}"'"'
        continue
    fi

    if [ -f "${out}.gz" ]; then
        echo 'warn: already exists: "'"${out}.gz"'"'
        continue
    fi

    cp -avL "${i}" "${out}"
    chmod a-wx "${out}"
    gzip "${out}"
done
