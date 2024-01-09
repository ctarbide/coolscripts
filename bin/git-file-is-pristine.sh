#!/bin/sh
# usage: git-file-is-pristine.sh git-file-is-pristine.sh && echo is pristine
set -eu
file=$1; shift

# does it even exists?
[ -e "${file}" ]

# not versioned implies nonpristine
other=`git ls-files -o -- "${file}"`
[ x"${other}" = x ]

# versioned and without differences to working copy?
exec git diff-index --quiet HEAD -- "${file}"
