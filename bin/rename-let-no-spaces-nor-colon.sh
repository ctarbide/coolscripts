#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -gt 0 ] || die 1 "usage: ${0##*/} file1 file2 ..."

strip_r_slash(){ echo "$1" | perl -pe's,/*$,,'; }

for i in ${1+"$@"}; do
    if ! test -f "$i" -o -d "$i"; then
        echo "error: file [$i] not found"
        continue
    fi

    i=`strip_r_slash "$i"`

    dirname=${i%/*}
    basename=`echo "${i##*/}" | perl -lpe'tr/ :/_-/'`

    if [ x"$dirname" = x"$i" ]; then
        if [ x"$i" != x"${basename}" ]; then
            if [ -e "${basename}" ]; then
                echo 'error: file "'"${basename}"'" already exists'
                continue
            fi
            mv -v "$i" "${basename}"
        fi
    else
        if [ x"$i" != x"${dirname}/${basename}" ]; then
            if [ -e "${dirname}/${basename}" ]; then
                echo 'error: file "'"${dirname}/${basename}"'" already exists'
                continue
            fi
            mv -v "$i" "${dirname}/${basename}"
        fi
    fi
done
