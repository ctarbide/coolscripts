#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -ge 1 ] || die 1 "usage: ${0##*/} dir   (use -gk2 or -k3 options to sort on size or name)"

strip_r_slash(){ echo "$1" | perl -pe's,/*$,,'; }

dir=`strip_r_slash "${1}"`
shift

test -d "${dir}" || die 1 'error: "'"${dir}"'" is not a directory'

LC_ALL=C
export LC_ALL

find "${dir}" -type f | perl -lne's,^\./,,; @s=stat;print(qq{$s[9] $s[7] $_})' | \
  perl -lne's/^(\d+) (\d+) //; ($s,$n,$h,$d,$m,$y)=localtime$1; printf(qq{%04d-%02d-%02d_%02dh%02dm%02d %12.12s %s\n},$y+1900,$m+1,$d,$h,$n,$s,$2,$_)' |
  sort -k1,1 -k3,3 "$@"
