#!/bin/sh
set -eu
#
# usage examples:
#
#    git-last-modified.sh README.txt
#
#    TZ=Pacific/Samoa FORMAT='format-local:%B %e, %Y at %T %Z' git-last-modified.sh README.txt
#
#    FORMAT=format:%F git-last-modified.sh README.txt | perl -lne'print(qq{<<LAST MODIFIED>>=\n${_}\n@})'
#
#    FORMAT=format:%s git-last-modified.sh README.txt
#
# will output the date of the last commit relevant to the file
#
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
git_find_blob(){
    treeish=$1; shift
    filename=$1; shift
    if [ x"${filename#.*/}" = x"${filename}" ]; then
        filename=./${filename}
    fi
    git rev-parse "${treeish}:${filename}"
}

FORMAT=${FORMAT:-format:%s %B %e, %Y at %T UTC}

for filename; do
    blob=`git_find_blob HEAD "${filename}"`
    if [ x"${blob}" = x ]; then
        die 1 "Error, could not find the blob for file \"${filename}\"" 1>&2
    fi
    git log -1 --format=%cd --date="${FORMAT}" --find-object="${blob}" HEAD
done
