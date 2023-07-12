#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
[ "$#" -gt 0 ] || die 1 "usage: ${0##*/} file1 file2 ..."
for i in ${1+"$@"}; do
    if ! test -f "$i"; then
        echo "error: file [$i] not found"
        continue
    fi
    sum=`sha1sum "$i" | perl -lne'chomp;print(substr($_,0,7));last'`
    filelocalstamp=`perl -MPOSIX=strftime -e'print(strftime(q{%Y-%m-%d_%Hh%Mm%S}, localtime((stat($ARGV[0]))[9])))' -- "$i"`
    echo "${i}: ${filelocalstamp}_${sum}"
done
