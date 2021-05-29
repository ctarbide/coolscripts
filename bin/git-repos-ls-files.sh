#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -gt 0 ] || die 1 "usage: ${0##*/} repos.git"

for i in ${1+"$@"}; do
    GIT_DIR="${i}" git ls-tree --full-tree -r --abbrev=10 -t -l HEAD
done

echo "all done for \"${0##*/}\""
